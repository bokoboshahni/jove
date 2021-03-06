# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stations`
#
# ### Columns
#
# Name                               | Type               | Attributes
# ---------------------------------- | ------------------ | ---------------------------
# **`id`**                           | `bigint`           | `not null, primary key`
# **`conquerable`**                  | `boolean`          | `not null`
# **`docking_cost_per_volume`**      | `decimal(, )`      | `not null`
# **`log_data`**                     | `jsonb`            |
# **`max_ship_volume_dockable`**     | `decimal(, )`      | `not null`
# **`name`**                         | `text`             | `not null`
# **`office_rental_cost`**           | `decimal(, )`      | `not null`
# **`position_x`**                   | `decimal(, )`      | `not null`
# **`position_y`**                   | `decimal(, )`      | `not null`
# **`position_z`**                   | `decimal(, )`      | `not null`
# **`reprocessing_efficiency`**      | `decimal(, )`      | `not null`
# **`reprocessing_station_take`**    | `decimal(, )`      | `not null`
# **`use_operation_name`**           | `boolean`          | `not null`
# **`created_at`**                   | `datetime`         | `not null`
# **`updated_at`**                   | `datetime`         | `not null`
# **`celestial_id`**                 | `bigint`           | `not null`
# **`corporation_id`**               | `bigint`           | `not null`
# **`graphic_id`**                   | `bigint`           | `not null`
# **`operation_id`**                 | `bigint`           | `not null`
# **`reprocessing_hangar_flag_id`**  | `bigint`           | `not null`
# **`type_id`**                      | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_stations_on_celestial_id`:
#     * **`celestial_id`**
# * `index_stations_on_corporation_id`:
#     * **`corporation_id`**
# * `index_stations_on_graphic_id`:
#     * **`graphic_id`**
# * `index_stations_on_operation_id`:
#     * **`operation_id`**
# * `index_stations_on_reprocessing_hangar_flag_id`:
#     * **`reprocessing_hangar_flag_id`**
# * `index_stations_on_type_id`:
#     * **`type_id`**
#
FactoryBot.define do
  factory :station do
    association :celestial, factory: :planet
    association :corporation, factory: :corporation
    association :graphic, factory: :graphic
    association :operation, factory: :station_operation
    association :type, factory: :type

    conquerable { false }
    docking_cost_per_volume { Faker::Number.decimal }
    max_ship_volume_dockable { Faker::Number.decimal }
    name { Faker::Space.agency }
    office_rental_cost { Faker::Number.decimal }
    position_x { Faker::Number.decimal }
    position_y { Faker::Number.decimal }
    position_z { Faker::Number.decimal }
    reprocessing_efficiency { Faker::Number.decimal }
    reprocessing_hangar_flag_id { Faker::Number.non_zero_digit }
    reprocessing_station_take { Faker::Number.decimal }
    use_operation_name { false }
  end
end
