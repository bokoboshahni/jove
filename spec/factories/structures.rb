# frozen_string_literal: true

# ## Schema Information
#
# Table name: `structures`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`discarded_at`**          | `datetime`         |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`name`**                  | `text`             | `not null`
# **`position_x`**            | `decimal(, )`      | `not null`
# **`position_y`**            | `decimal(, )`      | `not null`
# **`position_z`**            | `decimal(, )`      | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`corporation_id`**        | `bigint`           | `not null`
# **`solar_system_id`**       | `bigint`           | `not null`
# **`type_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_structures_on_corporation_id`:
#     * **`corporation_id`**
# * `index_structures_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_structures_on_type_id`:
#     * **`type_id`**
#
FactoryBot.define do
  factory :structure do
    corporation
    solar_system

    esi_etag { SecureRandom.hex }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::TvShows::TheExpanse.location }
    position_x { Faker::Number.decimal }
    position_y { Faker::Number.decimal }
    position_z { Faker::Number.decimal }
  end
end
