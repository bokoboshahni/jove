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
# **`refresh_error_code`**         | `text`             |
# **`refresh_error_description`**  | `text`             |
# **`refresh_error_status`**       | `integer`          |
# **`refresh_token`**              | `text`             |
# **`refreshed_at`**               | `datetime`         |
# **`rejected_at`**                | `datetime`         |
# **`revoked_at`**                 | `datetime`         |
# **`scopes`**                     | `text`             | `not null, is an Array`
# **`status`**                     | `enum`             | `not null`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`identity_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_esi_tokens_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_tokens_on_requester_id`:
#     * **`requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :esi_token do # rubocop:disable Metrics/BlockLength
    association :identity
    association :requester, factory: :identity
    scopes { Jove::ESI::SCOPES.shuffle.take(3) }

    after(:build) do |token|
      token.grants.build(type: 'ESIGrant::StructureDiscovery', requester: token.requester)
    end

    trait :approved do
      status { :approved }

      after(:create) do |token|
        token.grants.each(&:approve!)
      end
    end

    trait :rejected do
      status { :rejected }

      after(:create) do |token|
        token.grants.each(&:reject!)
      end
    end

    trait :authorized do
      status { :authorized }
      access_token { SecureRandom.hex(32) }
      refresh_token { SecureRandom.hex(32) }
      expires_at { 20.minutes.from_now }

      after(:build) do |token|
        token.grants.each(&:approve)
      end
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
