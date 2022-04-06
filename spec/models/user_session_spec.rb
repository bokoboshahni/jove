# frozen_string_literal: true

# ## Schema Information
#
# Table name: `user_sessions`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `uuid`             | `not null, primary key`
# **`identity_id`**  | `bigint`           | `not null`
# **`session_id`**   | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_unique_user_sessions` (_unique_):
#     * **`session_id`**
#     * **`identity_id`**
# * `index_user_sessions_on_identity_id`:
#     * **`identity_id`**
# * `index_user_sessions_on_session_id`:
#     * **`session_id`**
#
require 'rails_helper'

RSpec.describe UserSession, type: :model do
  describe '.from_sso' do
    subject(:user_session_model) { described_class }

    let(:auth) { double('OmniAuth::AuthHash', uid: character.id) }
    let(:character) { create(:character, :with_alliance) }
    let(:corporation) { character.corporation }
    let(:alliance) { character.alliance }

    let(:result) { user_session_model.from_sso!(auth) }

    shared_context 'permitted character' do
      before { create(:login_permit, permittable: character) }
    end

    shared_context 'registered character' do
      include_context 'permitted character'

      let(:user) { create(:user) }

      before { user.create_default_identity!(character:) }
    end

    shared_examples 'successful authentication' do
      it 'returns a valid session' do
        expect(result).to be_valid
      end
    end

    context 'with a registered character that is valid for login' do
      include_context 'registered character'

      include_examples 'successful authentication'
    end

    context 'with a registered character that is no longer valid for login' do
      include_context 'registered character'

      it 'returns an invalid session' do
        LoginPermit.find_by(permittable: character).destroy
        expect(result).to be_invalid
      end

      it 'adds a validation error' do
        LoginPermit.find_by(permittable: character).destroy
        expect(result.errors.of_kind?(:base, :not_permitted)).to be_truthy
      end
    end

    context 'with an unregistered character that is valid for login' do
      include_context 'permitted character'

      include_examples 'successful authentication'

      it 'creates a new user' do
        expect { result }.to change { User.count }.by(1)
      end

      it 'creates a default identity for the new user' do
        expect { result }.to(change { Identity.find_by(character_id: character.id, default: true) })
      end
    end

    context 'with an unregistered character that is not valid for login' do
      it 'does not create a new user' do
        expect { result }.not_to(change { User.count })
      end

      it 'returns an invalid session' do
        expect(result).to be_invalid
      end

      it 'adds a validation error' do
        expect(result.errors.of_kind?(:base, :not_permitted)).to be_truthy
      end
    end
  end
end
