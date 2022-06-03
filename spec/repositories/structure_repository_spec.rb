# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StructureRepository, type: :repository do
  subject(:repository) { StructureRepository.new(gateway:) }

  context 'with ESI gateway' do
    let(:gateway) { StructureRepository::ESIGateway.new }

    describe '#find' do
      context 'with an authorized grant' do
        before do
          allow(ESIGrant::StructureDiscovery).to(
            receive(:with_token).and_yield(SecureRandom.hex(32))
          )
        end

        context 'with a valid structure ID' do
          let(:structure_data) do
            {
              name: 'F-NMX6 - Mothership Bellicose',
              owner_id: 98_199_293,
              solar_system_id: 30_002_019,
              type_id: 35_834,
              position: {
                x: 888_947_649_775.0,
                y: 75_366_841_878.0,
                z: -623_928_547_627.0
              }
            }
          end

          let(:structure_id) { 1_039_149_782_071 }

          let(:headers) do
            {
              etag: SecureRandom.hex,
              expires: 24.hours.from_now.iso8601,
              'last-modified': 1.hour.ago.iso8601
            }
          end

          before do
            create(:corporation, id: structure_data[:owner_id])
            create(:solar_system, id: structure_data[:solar_system_id])

            stub_request(:get, "https://esi.evetech.net/latest/universe/structures/#{structure_id}/")
              .to_return(status: 200, body: structure_data.to_json, headers:)
          end

          it 'returns a structure' do
            expect(repository.find(structure_id)).to be_a(Structure)
          end
        end

        context 'with a structure ID that does not exist' do
          let(:structure_id) { 12_345_678 }

          before do
            stub_request(:get, "https://esi.evetech.net/latest/universe/structures/#{structure_id}/")
              .and_return(status: 404)
          end

          it 'raises an error' do
            expect { repository.find(structure_id) }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context 'when the structure is not expired' do
          let(:structure) { create(:structure, esi_expires_at: 1.hour.from_now) }

          it 'returns the structure' do
            expect(repository.find(structure.id)).to eq(structure)
          end

          it 'does not request the structure from ESI' do
            expect(WebMock).not_to have_requested(:get, %r{\Ahttps://esi\.evetech\.net})
          end
        end

        context 'with a structure that is expired' do
          let(:structure) { create(:structure, esi_expires_at: 1.hour.ago) }
          let(:corporation) { create(:corporation) }
          let(:data) do
            structure.slice(:name, :solar_system_id).merge(
              owner_id: corporation.id
            )
          end
          let(:headers) do
            {
              etag: SecureRandom.hex,
              expires: 24.hours.from_now.iso8601,
              'last-modified': 1.hour.ago.iso8601
            }
          end

          let(:result) { repository.find(structure.id) }

          before do
            stub_request(:get, "https://esi.evetech.net/latest/universe/structures/#{structure.id}/")
              .to_return(body: data.to_json, headers:)
          end

          it 'returns the structure' do
            expect(result).to eq(structure)
          end

          it 'updates the structure from ESI' do
            expect { result }.to change { structure.reload.corporation_id }.to(corporation.id)
          end

          it 'updates the ETag' do
            expect { result }.to change { structure.reload.esi_etag }.to(headers[:etag])
          end

          it 'updates the expiration timestamp' do
            expect { result }.to change { structure.reload.esi_expires_at }.to(headers[:expires].to_datetime)
          end

          it 'updates the last modified timestamp' do
            expect { result }.to change {
                                   structure.reload.esi_last_modified_at
                                 }.to(headers[:'last-modified'].to_datetime)
          end
        end

        context 'with a structure that no longer exists' do
          let!(:structure) { create(:structure, esi_expires_at: 1.hour.ago) }
          let(:corporation) { create(:corporation) }

          let(:result) { repository.find(structure.id) }

          before do
            stub_request(:get, "https://esi.evetech.net/latest/universe/structures/#{structure.id}/")
              .to_return(status: 404)
          end

          it 'discards the structure' do
            expect { result }.to(change { structure.reload.discarded? }.to(true))
          end

          it 'returns the structure' do
            expect(result).to eq(structure)
          end
        end
      end
    end
  end
end
