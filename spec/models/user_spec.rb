# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`admin`**       | `boolean`          |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#destroy' do
    let(:user) { create(:registered_user) }

    it 'fails if user is only admin' do
      admin = create(:admin_user)
      expect(admin.destroy).to be_falsey
    end

    it 'fails if destroyer is set and destroyer is the user' do
      user.destroyer = user
      expect(user.destroy).to be_falsey
    end

    it 'succeeds if destroyer is set and destroyer is not the user' do
      user.destroyer = create(:registered_user)
      expect(user.destroy).to be_truthy
    end

    it 'succeeds if destroyer is not set' do
      expect(user.destroy).to be_truthy
    end
  end

  describe '#create_identity_from_sso!' do
    subject(:user) { create(:user) }

    context 'with an unregistered character that is valid for login', vcr: { allow_playback_repeats: true } do
      let(:character_id) { 2_117_692_215 }
      let(:auth) { double('OmniAuth::AuthHash', uid: character_id) }

      before do
        character_repository = CharacterRepository.new(gateway: CharacterRepository::ESIGateway.new)
        character = character_repository.find(character_id)
        create(:login_permit, permittable: character)
      end

      it 'creates an identity for the character' do
        expect(user.create_identity_from_sso!(auth)).to be_persisted
      end

      it 'returns the new identity' do
        expect(user.create_identity_from_sso!(auth).character_id).to eq(character_id)
      end
    end

    context 'with an unregistered character that is not valid for login', vcr: true do
      let(:character_id) { 2_117_692_215 }
      let(:auth) { double('OmniAuth::AuthHash', uid: character_id) }

      it 'does not persist the new identity' do
        expect(user.create_identity_from_sso!(auth)).not_to be_persisted
      end

      it 'returns the new identity with errors' do
        expect(user.create_identity_from_sso!(auth).errors).to include(:base)
      end
    end

    context 'with a registered character' do
      let(:character) { create(:character) }
      let(:auth) { double('OmniAuth::AuthHash', uid: character.id) }

      before do
        create(:login_permit, permittable: character)
        create(:identity, character:, user:)
      end

      it 'does not persist the new identity' do
        expect(user.create_identity_from_sso!(auth)).not_to be_persisted
      end

      it 'returns the new identity with errors' do
        expect(user.create_identity_from_sso!(auth).errors).to include(:character_id)
      end
    end
  end
end
