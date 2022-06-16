# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_order_sources`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `integer`          | `not null, primary key`
# **`disabled_at`**         | `datetime`         |
# **`expires_at`**          | `datetime`         |
# **`fetched_at`**          | `datetime`         |
# **`fetching_at`**         | `datetime`         |
# **`fetching_failed_at`**  | `datetime`         |
# **`name`**                | `text`             | `not null`
# **`pending_at`**          | `datetime`         |
# **`source_type`**         | `string`           | `not null`
# **`status`**              | `enum`             | `not null`
# **`status_exception`**    | `jsonb`            |
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
# **`source_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_market_order_sources` (_unique_):
#     * **`source_type`**
#     * **`source_id`**
#
require 'rails_helper'

RSpec.describe MarketOrderSource, type: :model do
  subject(:source) { create(:market_order_source, :pending) }

  describe '.fetchable' do
    let!(:fetchables) { create_list(:market_order_source, 2, :fetchable, :expired) }
    let!(:non_fetchables) { create_list(:market_order_source, 2, :fetched) }

    it 'returns fetchable sources' do
      expect(described_class.fetchable).to include(*fetchables)
    end

    it 'does not return non-fetchable sources' do
      expect(described_class.fetchable).not_to include(*non_fetchables)
    end
  end

  describe '#enable!' do
    context 'when source is a region' do
      let(:source) { create(:market_order_source) }

      it 'enables the market order source' do
        expect(source.enable!).to be_truthy
      end
    end

    context 'when source is a structure with no grants' do
      subject(:source) { create(:market_order_source, source: create(:structure)) }

      it 'raises an error' do
        expect { source.enable! }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when source is a structure with an authorized grant' do
      let(:structure) { create(:structure) }

      subject(:source) { create(:market_order_source, source: structure) }

      before do
        create(:esi_token, :authorized, grant_type: :structure_market, resource: structure)
      end

      it 'enables the market order source' do
        expect(source.enable!).to be_truthy
      end
    end

    context 'when source is a structure with an unauthorized grant' do
      let(:structure) { create(:structure) }

      subject(:source) { create(:market_order_source, source: structure) }

      before do
        create(:esi_token, resource: structure)
      end

      it 'raises an error' do
        expect { source.enable! }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  describe '#fetch!' do
    let(:snapshot) { instance_double('MarketOrderSnapshot') }
    let(:snapshots) { instance_double('ActiveRecord::Associations::CollectionProxy') }
    let(:etag) { SecureRandom.hex(32) }
    let(:expires_at) { Time.zone.now + 5.minutes }

    before do
      allow(source).to receive(:snapshots).and_return(snapshots)
      allow(snapshot).to receive(:fetch!).and_return(true)
      allow(snapshot).to receive(:reload).and_return(snapshot)
      allow(snapshot).to receive(:esi_etag).and_return(etag)
      allow(snapshot).to receive(:esi_expires_at).and_return(expires_at)
      allow(snapshots).to receive(:create!).and_return(snapshot)
    end

    context 'when fetching succeeds' do
      it 'sets the expiration to the ESI expiry' do
        source.fetch!
        expect(source.expires_at).to eq(expires_at)
      end

      it 'adds the etag to the list of etags' do
        source.fetch!
        expect(source.latest_etag).to eq(etag)
      end
    end

    context 'when not expired' do
      it 'raises an error' do
        allow(subject).to receive(:expired?).and_return(false)
        expect { source.fetch! }.to raise_error(AASM::InvalidTransition)
      end
    end

    context 'when fetching fails' do
      before do
        allow(snapshot).to receive(:fetch!).and_raise(Jove::ESI::ServerError)
      end

      it 'transitions to the fetching failed state' do
        expect { suppress(Exception) { source.fetch! } }
          .to(change { source.fetching_failed? }.to(true))
      end

      it 'raises the exception' do
        expect { source.fetch! }.to raise_error(Jove::ESI::ServerError)
      end
    end

    context 'when fetching fails due to an expired grant' do
      before do
        allow(snapshot).to receive(:fetch!).and_raise(MarketOrderSnapshot::NoAuthorizedGrantsError)
      end

      it 'transitions to the disabled state' do
        expect { suppress(Exception) { source.fetch! } }
          .to(change { source.disabled? }.to(true))
      end

      it 'raises the exception' do
        expect { source.fetch! }.to raise_error(MarketOrderSnapshot::NoAuthorizedGrantsError)
      end
    end
  end

  describe '#available?' do
    it 'returns true if the source is fetched and not expired' do
      allow(source).to receive(:fetched?).and_return(true)
      allow(source).to receive(:expired?).and_return(false)
      expect(source.available?).to be_truthy
    end

    it 'returns false if the source is disabled' do
      allow(source).to receive(:disabled?).and_return(true)
      expect(source.available?).to be_falsey
    end

    it 'returns false if the source if fetched and expired' do
      allow(source).to receive(:fetched?).and_return(true)
      allow(source).to receive(:expired?).and_return(true)
      expect(source.available?).to be_falsey
    end

    it 'returns false if the source is not fetched' do
      allow(source).to receive(:fetched?).and_return(false)
      expect(source.available?).to be_falsey
    end
  end

  describe '#expired?' do
    it 'returns true if the source has never been fetched' do
      allow(source).to receive(:expires_at).and_return(nil)
      expect(source.expired?).to be_truthy
    end

    it 'returns true if the current time is greater than the expiration time' do
      allow(source).to receive(:expires_at).and_return(5.minutes.ago)
      expect(source.expired?).to be_truthy
    end

    it 'returns false if the current time is not greater than the expiration time' do
      allow(source).to receive(:expires_at).and_return(5.minutes.from_now)
      expect(source.expired?).to be_falsey
    end
  end

  describe '#fetchable?' do
    it 'returns false if source is currently fetching' do
      allow(source).to receive(:fetching?).and_return(true)
      expect(source.fetchable?).to be_falsey
    end

    it 'returns true if fetching failed' do
      allow(source).to receive(:fetching?).and_return(false)
      allow(source).to receive(:fetching_failed?).and_return(true)
      expect(source.fetchable?).to be_truthy
    end

    it 'returns true if expired' do
      allow(source).to receive(:fetching?).and_return(false)
      allow(source).to receive(:fetching_failed?).and_return(false)
      allow(source).to receive(:expired?).and_return(true)
      expect(source.fetchable?).to be_truthy
    end

    it 'returns false if not failed or expired' do
      allow(source).to receive(:fetching?).and_return(false)
      allow(source).to receive(:fetching_failed?).and_return(false)
      allow(source).to receive(:expired?).and_return(false)
      expect(source.fetchable?).to be_falsey
    end
  end

  describe '#latest' do
    it 'returns the latest fetched snapshot by fetched time' do
      create(:market_order_snapshot, :fetched, source:, fetched_at: 10.minutes.ago)
      latest = create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)
      create(:market_order_snapshot, :failed, source:)

      expect(source.latest).to eq(latest)
    end

    it 'returns nil when there are no snapshots' do
      expect(source.latest).to be_nil
    end
  end

  describe '#latest_at' do
    it 'returns the creation time of the latest snapshot' do
      latest = create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)
      expect(source.latest_at.to_i).to eq(latest.created_at.to_i)
    end

    it 'returns nil when there are no snapshots' do
      expect(source.latest_at).to be_nil
    end
  end

  describe '#previous' do
    it 'returns the second latest fetched snapshot by fetched time' do
      previous = create(:market_order_snapshot, :fetched, source:, fetched_at: 10.minutes.ago)
      create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)
      create(:market_order_snapshot, :failed, source:)

      expect(source.previous).to eq(previous)
    end

    it 'returns nil when there is only one snapshot' do
      create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)

      expect(source.previous).to be_nil
    end

    it 'returns nil when there are no snapshots' do
      expect(source.previous).to be_nil
    end
  end

  describe '#previous_at' do
    it 'returns the creation time of the latest snapshot' do
      previous = create(:market_order_snapshot, :fetched, source:, fetched_at: 10.minutes.ago)
      create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)
      expect(source.previous_at.to_i).to eq(previous.created_at.to_i)
    end

    it 'returns nil when there is only one snapshot' do
      create(:market_order_snapshot, :fetched, source:, fetched_at: 5.minutes.ago)
      expect(source.previous_at).to be_nil
    end

    it 'returns nil when there are no snapshots' do
      expect(source.previous_at).to be_nil
    end
  end

  describe '#source_url' do
    it 'uses the region market endpoint for regions' do
      expect(source.source_url).to eq("https://esi.evetech.net/latest/markets/#{source.source_id}/orders/")
    end

    it 'uses the structure market endpoint for structures' do
      source.source = create(:structure)
      expect(source.source_url).to eq("https://esi.evetech.net/latest/markets/structures/#{source.source_id}/")
    end
  end
end
