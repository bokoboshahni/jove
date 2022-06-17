# frozen_string_literal: true

# ## Schema Information
#
# Table name: `login_permits`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`name`**              | `text`             | `not null`
# **`permittable_type`**  | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`permittable_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_login_permits` (_unique_):
#     * **`permittable_type`**
#     * **`permittable_id`**
#
require 'rails_helper'

RSpec.describe LoginPermit, type: :model do
  describe '.permitted?' do
    it 'returns true if a login permit for the permittable exists' do
      character = create(:character, :with_login_permit)
      expect(LoginPermit.permitted?(character)).to be_truthy
    end

    it 'returns false if a login permit for the permittable does not exist' do
      character = create(:character)
      expect(LoginPermit.permitted?(character)).to be_falsey
    end
  end

  describe '#locked?' do
    it 'returns true if the permittable is an identity for an admin user' do
      login_permit = create(:admin_user).default_character.login_permit
      expect(login_permit).to be_locked
    end

    it 'returns false if the permittable is an identity for a regular user' do
      login_permit = create(:registered_user).default_character.login_permit
      expect(login_permit).not_to be_locked
    end

    it 'returns false if the permittable is not a character' do
      corporation = create(:corporation)
      login_permit = create(:login_permit, permittable: corporation)
      expect(login_permit).not_to be_locked
    end
  end
end
