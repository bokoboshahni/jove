# frozen_string_literal: true

# ## Schema Information
#
# Table name: `characters`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`birthday`**              | `date`             | `not null`
# **`description`**           | `text`             |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`gender`**                | `text`             | `not null`
# **`name`**                  | `text`             | `not null`
# **`owner_hash`**            | `text`             |
# **`security_status`**       | `decimal(, )`      |
# **`title`**                 | `text`             |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`bloodline_id`**          | `bigint`           | `not null`
# **`corporation_id`**        | `bigint`           | `not null`
# **`faction_id`**            | `bigint`           |
# **`race_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_characters_on_bloodline_id`:
#     * **`bloodline_id`**
# * `index_characters_on_corporation_id`:
#     * **`corporation_id`**
# * `index_characters_on_faction_id`:
#     * **`faction_id`**
# * `index_characters_on_race_id`:
#     * **`race_id`**
#
require 'rails_helper'

RSpec.describe Character, type: :model do
  describe '.from_esi' do
    subject(:model) { described_class }

    context 'with a character that has not been fetched', vcr: true do
      let(:character_id) { 2_113_024_536 }

      it 'returns the new character' do
        expect(model.from_esi(character_id).id).to eq(character_id)
      end
    end

    context 'with a character that has been fetched and is not expired' do
      let(:character) { create(:character) }

      it 'returns the character' do
        expect(model.from_esi(character.id)).to eq(character)
      end
    end

    context 'with a character that has been fetched and is expired' do
      let(:character) { create(:character, esi_expires_at: 1.hour.ago) }

      let(:headers) do
        {
          etag: SecureRandom.hex,
          expires: 24.hours.from_now.iso8601,
          'last-modified': 1.hour.ago.iso8601
        }
      end

      before do
        stub_request(:get, "https://esi.evetech.net/latest/characters/#{character.id}/")
          .to_return(body: {}.to_json, headers:)
      end

      it 'returns the updated character' do
        expect(model.from_esi(character.id).esi_expires_at).to eq(headers[:expires].to_datetime)
      end
    end

    context 'with a character that does not exist' do
      let(:character_id) { 1_234_567_890 }

      before do
        stub_request(:get, "https://esi.evetech.net/latest/characters/#{character_id}/")
          .to_return(status: 404, body: {}.to_json)
      end

      it 'raises an error' do
        expect { model.from_esi(character_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
