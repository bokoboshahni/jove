# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharacterRepository, type: :repository do
  subject(:repository) { CharacterRepository.new(gateway:) }

  context 'with ESI gateway' do
    let(:gateway) { CharacterRepository::ESIGateway.new }

    describe '#find' do
      context 'with a valid character ID', vcr: true do
        let(:character_id) { 2_113_024_536 }

        it 'returns a character' do
          expect(repository.find(character_id)).to be_a(Character)
        end
      end

      context 'with an character ID that does not exist', vcr: true do
        let(:character_id) { 12_345_678 }

        it 'raises an error' do
          expect { repository.find(character_id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when the character is not expired' do
        let(:character) { create(:character, esi_expires_at: 1.hour.from_now) }

        it 'returns the character' do
          expect(repository.find(character.id)).to eq(character)
        end

        it 'does not request the character from ESI' do
          expect(WebMock).not_to have_requested(:get, %r{\Ahttps://esi\.evetech\.net})
        end
      end

      context 'with a character that is expired' do
        let(:character) { create(:character, esi_expires_at: 1.hour.ago) }
        let(:corporation) { create(:corporation) }
        let(:data) do
          {
            corporation_id: corporation.id
          }
        end
        let(:headers) do
          {
            etag: SecureRandom.hex,
            expires: 24.hours.from_now.iso8601,
            'last-modified': 1.hour.ago.iso8601
          }
        end

        let(:result) { repository.find(character.id) }

        before do
          stub_request(:get, "https://esi.evetech.net/latest/characters/#{character.id}/")
            .to_return(body: data.to_json, headers:)
        end

        it 'returns the character' do
          expect(result).to eq(character)
        end

        it 'updates the character from ESI' do
          expect { result }.to change { character.reload.corporation_id }.to(corporation.id)
        end

        it 'updates the ETag' do
          expect { result }.to change { character.reload.esi_etag }.to(headers[:etag])
        end

        it 'updates the expiration timestamp' do
          expect { result }.to change { character.reload.esi_expires_at }.to(headers[:expires].to_datetime)
        end

        it 'updates the last modified timestamp' do
          expect { result }.to change {
                                 character.reload.esi_last_modified_at
                               }.to(headers[:'last-modified'].to_datetime)
        end
      end
    end
  end
end
