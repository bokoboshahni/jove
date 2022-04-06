# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllianceRepository, type: :repository do
  subject(:repository) { AllianceRepository.new(gateway:) }

  context 'with ESI gateway' do
    let(:gateway) { AllianceRepository::ESIGateway.new }

    describe '#find' do
      context 'with a valid alliance ID', vcr: true do
        let(:alliance_id) { 99_003_214 }

        it 'returns an alliance' do |_example|
          expect(repository.find(alliance_id)).to be_a(Alliance)
        end
      end

      context 'with an alliance ID that does not exist', vcr: true do
        let(:alliance_id) { 12_345_678 }

        it 'raises an error' do
          expect { repository.find(alliance_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'with an alliance that is not expired' do
        let(:alliance) { create(:alliance, esi_expires_at: 1.hour.from_now) }

        it 'returns the alliance' do
          expect(repository.find(alliance.id)).to eq(alliance)
        end

        it 'does not request the alliance from ESI' do
          expect(WebMock).not_to have_requested(:get, %r{\Ahttps://esi\.evetech\.net})
        end
      end

      context 'with an alliance that is expired' do
        let(:alliance) { create(:alliance, esi_expires_at: 1.hour.ago) }

        let(:corporation) { create(:corporation, alliance:) }
        let(:data) do
          {
            date_founded: corporation.founded_on.iso8601,
            executor_corporation_id: corporation.id
          }
        end
        let(:headers) do
          {
            etag: SecureRandom.hex,
            expires: 24.hours.from_now.iso8601,
            'last-modified': 1.hour.ago.iso8601
          }
        end

        let(:result) { repository.find(alliance.id) }

        before do
          stub_request(:get, "https://esi.evetech.net/latest/alliances/#{alliance.id}/")
            .to_return(body: data.to_json, headers:)
        end

        it 'returns the alliance' do
          expect(result).to eq(alliance)
        end

        it 'updates the alliance from ESI' do
          expect { result }.to change { alliance.reload.executor_corporation_id }.to(corporation.id)
        end

        it 'updates the ETag' do
          expect { result }.to change { alliance.reload.esi_etag }.to(headers[:etag])
        end

        it 'updates the expiration timestamp' do
          expect { result }.to change { alliance.reload.esi_expires_at }.to(headers[:expires].to_datetime)
        end

        it 'updates the last modified timestamp' do
          expect { result }.to change { alliance.reload.esi_last_modified_at }.to(headers[:'last-modified'].to_datetime)
        end
      end
    end
  end
end
