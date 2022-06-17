# frozen_string_literal: true

# ## Schema Information
#
# Table name: `esi_tokens`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`access_token`**               | `text`             |
# **`approved_at`**                | `datetime`         |
# **`authorized_at`**              | `datetime`         |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`grant_type`**                 | `text`             |
# **`refresh_error_code`**         | `text`             |
# **`refresh_error_description`**  | `text`             |
# **`refresh_error_status`**       | `integer`          |
# **`refresh_token`**              | `text`             |
# **`refreshed_at`**               | `datetime`         |
# **`rejected_at`**                | `datetime`         |
# **`resource_type`**              | `string`           |
# **`revoked_at`**                 | `datetime`         |
# **`scopes`**                     | `text`             | `not null, is an Array`
# **`status`**                     | `enum`             | `not null`
# **`used_at`**                    | `datetime`         |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`identity_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`resource_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_esi_tokens_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_tokens_on_requester_id`:
#     * **`requester_id`**
# * `index_esi_tokens_with_resources`:
#     * **`grant_type`**
#     * **`resource_type`**
#     * **`resource_id`**
# * `index_unique_esi_token_access_tokens` (_unique_):
#     * **`access_token`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :esi_token do
    association :identity
    association :requester, factory: :identity

    grant_type { :structure_discovery }

    trait :approved do
      status { :approved }
    end

    trait :rejected do
      status { :rejected }
    end

    trait :authorized do
      status { :authorized }
      access_token { SecureRandom.hex(32) }
      refresh_token { SecureRandom.hex(32) }
      expires_at { 20.minutes.from_now }
    end

    trait :expired do
      status { :expired }
      refresh_error_code { 'invalid_credentials' }
      refresh_error_description { 'Invalid credentials' }
      refresh_error_status { 422 }
      access_token { nil }
      refresh_token { nil }
      expires_at { nil }
    end
  end
end
