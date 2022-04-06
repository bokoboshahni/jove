# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                           | Type               | Attributes
# ------------------------------ | ------------------ | ---------------------------
# **`id`**                       | `bigint`           | `not null, primary key`
# **`esi_etag`**                 | `text`             | `not null`
# **`esi_expires_at`**           | `datetime`         | `not null`
# **`esi_last_modified_at`**     | `datetime`         | `not null`
# **`founded_on`**               | `date`             | `not null`
# **`name`**                     | `text`             | `not null`
# **`ticker`**                   | `text`             | `not null`
# **`created_at`**               | `datetime`         | `not null`
# **`updated_at`**               | `datetime`         | `not null`
# **`creator_corporation_id`**   | `bigint`           | `not null`
# **`creator_id`**               | `bigint`           | `not null`
# **`executor_corporation_id`**  | `bigint`           |
# **`faction_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_alliances_on_creator_corporation_id`:
#     * **`creator_corporation_id`**
# * `index_alliances_on_creator_id`:
#     * **`creator_id`**
# * `index_alliances_on_executor_corporation_id`:
#     * **`executor_corporation_id`**
# * `index_alliances_on_faction_id`:
#     * **`faction_id`**
#
FactoryBot.define do
  factory :alliance do
    association :creator, factory: :character
    association :creator_corporation, factory: :corporation

    founded_on { Faker::Date.backward(days: 3650) }
    id { Faker::Number.within(range: 99_000_000..100_000_000) }
    esi_etag { SecureRandom.hex }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Company.name }
    ticker { Faker::Finance.ticker }
  end
end
