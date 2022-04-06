# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`description`**           | `text`             |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`founded_on`**            | `date`             |
# **`member_count`**          | `integer`          | `not null`
# **`name`**                  | `text`             | `not null`
# **`share_count`**           | `integer`          |
# **`tax_rate`**              | `decimal(, )`      | `not null`
# **`ticker`**                | `text`             | `not null`
# **`url`**                   | `text`             |
# **`war_eligible`**          | `boolean`          |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`alliance_id`**           | `bigint`           |
# **`ceo_id`**                | `bigint`           | `not null`
# **`creator_id`**            | `bigint`           | `not null`
# **`faction_id`**            | `bigint`           |
# **`home_station_id`**       | `bigint`           |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_corporations_on_ceo_id`:
#     * **`ceo_id`**
# * `index_corporations_on_creator_id`:
#     * **`creator_id`**
# * `index_corporations_on_faction_id`:
#     * **`faction_id`**
# * `index_corporations_on_home_station_id`:
#     * **`home_station_id`**
#
FactoryBot.define do
  factory :corporation do
    ceo_id { Faker::Number.within(range: 90_000_000..98_000_000) }
    creator_id { Faker::Number.within(range: 90_000_000..98_000_000) }

    esi_etag { SecureRandom.hex }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    founded_on { Faker::Date.backward(days: 365 * 10) }
    id { Faker::Number.within(range: 98_000_000..99_000_000) }
    member_count { Faker::Number.within(range: 1..12_601) }
    name { Faker::Company.name }
    share_count { Faker::Number.within(range: 1..1_000) }
    tax_rate { Faker::Number.within(range: 0.0..1.0) }
    ticker { Faker::Finance.ticker }

    trait :with_alliance do
      association :alliance, factory: :alliance
    end
  end
end
