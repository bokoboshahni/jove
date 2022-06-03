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
FactoryBot.define do
  factory :character do
    association :corporation, factory: :corporation
    bloodline_id { Faker::Number.within(range: 1..27) }
    race_id { Faker::Number.within(range: 1..135) }

    birthday { Faker::Date.backward(days: 3650) }
    id { Faker::Number.within(range: 90_000_000..98_000_000) }
    esi_etag { SecureRandom.hex }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    gender { Faker::Gender.binary_type.downcase }
    name { Faker::Name.name }

    trait :with_alliance do
      association :alliance, factory: :alliance
      corporation { alliance.creator_corporation }
    end

    trait :with_login_permit do
      after(:create) do |character, _|
        create(:login_permit, permittable: character)
      end
    end

    factory :permitted_character, traits: %i[with_login_permit]
  end
end
