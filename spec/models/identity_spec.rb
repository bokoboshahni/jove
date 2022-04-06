# frozen_string_literal: true

# ## Schema Information
#
# Table name: `identities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`default`**       | `boolean`          |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`user_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_identities_on_character_id` (_unique_):
#     * **`character_id`**
# * `index_identities_on_user_id`:
#     * **`user_id`**
# * `index_unique_default_identities` (_unique_):
#     * **`user_id`**
#     * **`default`**
#
require 'rails_helper'

RSpec.describe Identity, type: :model do
  describe '#destroy' do
    let(:user) { create(:registered_user) }

    it 'fails for the default identity' do
      expect(user.identities.find_by(default: true).destroy).to be_falsey
    end

    it 'succeeds for non-default identities' do
      character = create(:character, :with_login_permit)
      identity = create(:identity, user:, character:)
      expect(identity.destroy).to be_truthy
    end
  end

  describe '#valid_for_login?' do
    subject(:identity) { build(:identity, character:) }

    context 'with a permitted character' do
      let(:character) { create(:character, :with_alliance) }

      before { create(:login_permit, permittable: character) }

      it { is_expected.to be_valid }
    end

    context 'with a permitted corporation and no alliance' do
      let(:character) { create(:character, corporation:) }
      let(:corporation) { create(:corporation) }

      before { create(:login_permit, permittable: corporation) }

      it { is_expected.to be_valid }
    end

    context 'with a permitted alliance and non-permitted corporation' do
      let(:character) { create(:character, corporation:) }
      let(:corporation) { create(:corporation, :with_alliance) }

      before { create(:login_permit, permittable: corporation.alliance) }

      it { is_expected.to be_valid }
    end

    context 'with a non-permitted character' do
      let(:character) { create(:character) }

      it { is_expected.to be_invalid }
    end
  end
end
