# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_order_snapshots`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`esi_etag`**              | `text`             |
# **`esi_expires_at`**        | `datetime`         | `primary key`
# **`esi_last_modified_at`**  | `datetime`         |
# **`failed_at`**             | `datetime`         |
# **`fetched_at`**            | `datetime`         |
# **`fetching_at`**           | `datetime`         |
# **`skipped_at`**            | `datetime`         |
# **`status`**                | `enum`             | `not null`
# **`status_exception`**      | `jsonb`            |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`source_id`**             | `integer`          | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_order_snapshots` (_unique_):
#     * **`source_id`**
#     * **`esi_expires_at`**
#     * **`created_at`**
# * `market_order_snapshots_created_at_idx`:
#     * **`created_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => market_order_sources.id`**
#
require 'rails_helper'

RSpec.describe MarketOrderSnapshot, type: :model do
  describe '#fetch!' do
    let(:source) { create(:market_order_source, status: :pending) }

    let(:etag) { SecureRandom.hex(32) }
    let(:expires) { Time.zone.now + 5.minutes }
    let(:last_modified) { Time.zone.now }
    let(:pages) { 1 }
    let(:headers) do
      {
        'expires' => expires,
        'etag' => etag,
        'last-modified' => last_modified,
        'X-Pages' => pages
      }
    end

    let(:orders) do
      build_list(:market_order, 10, source_id: source.id).map(&:as_esi_json)
    end

    subject(:snapshot) { source.snapshots.create }

    before do
      stub_request(:head, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/")
        .to_return(status: 200, headers:)

      stub_request(:get, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/?page=1")
        .to_return(body: orders.to_json, status: 200, headers:)
    end

    shared_examples 'order persistence' do
      it 'persists each order' do
        orders.each do |esi_order|
          order = MarketOrder.find_by!(order_id: esi_order[:order_id])
          expect(order.duration).to eq(esi_order[:duration])
          expect(order.is_buy_order).to eq(esi_order[:is_buy_order])
          expect(order.issued).to eq(esi_order[:issued].to_datetime)
          expect(order.min_volume).to eq(esi_order[:min_volume])
          expect(order.price).to eq(esi_order[:price])
          expect(order.range).to eq(esi_order[:range])
          expect(order.system_id).to eq(esi_order[:system_id])
          expect(order.type_id).to eq(esi_order[:type_id])
          expect(order.volume_remain).to eq(esi_order[:volume_remain])
          expect(order.volume_total).to eq(esi_order[:volume_total])
        end
      end
    end

    it 'updates the status to fetched' do
      expect { snapshot.fetch! }.to(change { snapshot.reload.fetched? }.to(true))
    end

    context 'with a previous fetch error' do
      subject(:snapshot) { source.snapshots.create(status: :failed, status_exception: StandardError.new('Failed')) }

      it 'clears the status exception' do
        expect { snapshot.fetch! }.to(change { snapshot.reload.status_exception }.to(nil))
      end
    end

    context 'with one page' do
      before do
        snapshot.fetch!
      end

      include_examples 'order persistence'
    end

    context 'with multiple pages' do
      let(:pages) { 2 }

      before do
        stub_request(:get, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/?page=1")
          .to_return(body: orders.take(5).to_json, status: 200, headers:)

        stub_request(:get, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/?page=2")
          .to_return(body: orders.reverse.take(5).to_json, status: 200, headers:)

        snapshot.fetch!
      end

      include_examples 'order persistence'
    end

    context 'when orders have not been modified' do
      before do
        snapshot.source.fetch!

        stub_request(:head, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/")
          .to_return(status: 304, headers: headers.merge('expires' => 5.minutes.from_now))

        travel_to 10.minutes.from_now
        snapshot.source.fetch!
      end

      after { travel_back }

      it 'skips the snapshot' do
        expect(snapshot.source.snapshots.order(created_at: :desc).first).to be_skipped
      end
    end

    context 'with a structure' do
      let(:structure) { create(:structure) }
      let(:source) { create(:market_order_source, source: structure) }

      let(:orders) do
        orders = build_list(:market_order, 10, source_id: source.id).map(&:as_esi_json)
        orders.each { |o| o.delete(:system_id) }
        orders
      end

      context 'with a valid token' do
        before do
          stub_request(:head, "https://esi.evetech.net/latest/markets/structures/#{source.source_id}/")
            .to_return(status: 200, headers:)

          stub_request(:get, "https://esi.evetech.net/latest/markets/structures/#{source.source_id}/?page=1")
            .to_return(body: orders.to_json, status: 200, headers:)

          create(:esi_token, :authorized, grant_type: :structure_market, resource: structure)

          snapshot.fetch!
        end

        it 'persists each order with the structure solar system' do
          orders.each do |esi_order|
            order = MarketOrder.find_by!(order_id: esi_order[:order_id])
            expect(order.system_id).to eq(structure.solar_system_id)
          end
        end
      end

      context 'with an invalid token' do
        before do
          create(:esi_token, :expired, grant_type: :structure_market, resource: structure)
        end

        it 'raises an error' do
          expect { snapshot.fetch! }.to raise_error(MarketOrderSnapshot::NoAuthorizedGrantsError)
        end
      end
    end

    [400, 403, 404, 420, 422, 500, 502, 503, 504].each do |status|
      context "with a #{status} error" do
        before do
          stub_request(:get, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/?page=1")
            .to_return(status:)
        end

        it 'raises an error' do
          expect { snapshot.fetch! }.to raise_error(Jove::ESI::ERROR_CODE_CLASSES.fetch(status))
        end

        it 'sets the status exception' do
          expect { suppress(Exception) { snapshot.fetch! } }.to(change { snapshot.reload.status_exception })
        end
      end
    end

    context 'with an unhandled error' do
      before do
        stub_request(:get, "https://esi.evetech.net/latest/markets/#{source.source_id}/orders/?page=1")
          .to_return(status: 555)
      end

      it 'raises an error' do
        expect { snapshot.fetch! }.to raise_error(Jove::ESI::Error)
      end

      it 'sets the status exception' do
        expect { suppress(Exception) { snapshot.fetch! } }.to(change { snapshot.reload.status_exception })
      end
    end
  end
end
