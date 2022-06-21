# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CorporationRepository, type: :repository do
  subject(:repository) { CorporationRepository.new(gateway:) }

  context 'with ESI gateway' do
    let(:gateway) { CorporationRepository::ESIGateway.new }

    describe '#find' do
      context 'with a valid corporation ID', vcr: true do
        let(:corporation_id) { 98_199_293 }

        it 'returns a corporation' do
          expect(repository.find(corporation_id)).to be_a(Corporation)
        end
      end

      context 'with a corporation in an alliance', vcr: true do
        let(:corporation_id) { 98_199_293 }

        it 'syncs the alliance' do
          expect { repository.find(corporation_id) }.to(change { Alliance.count }.by(1))
        end
      end

      context 'with an corporation ID that does not exist', vcr: true do
        let(:corporation_id) { 12_345_678 }

        it 'raises an error' do
          expect { repository.find(corporation_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the corporation is not expired' do
        let(:corporation) { create(:corporation, esi_expires_at: 1.hour.from_now) }

        it 'returns the corporation' do
          expect(repository.find(corporation.id)).to eq(corporation)
        end

        it 'does not request the corporation from ESI' do
          expect(WebMock).not_to have_requested(:get, %r{\Ahttps://esi\.evetech\.net})
        end
      end

      context 'with a corporation that is expired' do
        let(:corporation) { create(:corporation, esi_expires_at: 1.hour.ago) }
        let(:data) do
          {
            date_founded: corporation.founded_on.iso8601,
            member_count: corporation.member_count + 10,
            shares: corporation.share_count
          }
        end
        let(:headers) do
          {
            etag: SecureRandom.hex,
            expires: 24.hours.from_now.iso8601,
            'last-modified': 1.hour.ago.iso8601
          }
        end

        let(:result) { repository.find(corporation.id) }

        before do
          stub_request(:get, "https://esi.evetech.net/latest/corporations/#{corporation.id}/")
            .to_return(body: data.to_json, headers:)
        end

        it 'returns the corporation' do
          expect(result).to eq(corporation)
        end

        it 'updates the corporation from ESI' do
          expect { result }.to change { corporation.reload.member_count }.to(corporation.member_count + 10)
        end

        it 'updates the ETag' do
          expect { result }.to change { corporation.reload.esi_etag }.to(headers[:etag])
        end

        it 'updates the expiration timestamp' do
          expect { result }.to change { corporation.reload.esi_expires_at }.to(headers[:expires].to_datetime)
        end

        it 'updates the last modified timestamp' do
          expect { result }.to change {
                                 corporation.reload.esi_last_modified_at
                               }.to(headers[:'last-modified'].to_datetime)
        end
      end
    end
  end
end
