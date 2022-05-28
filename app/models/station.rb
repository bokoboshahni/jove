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
class Station < ApplicationRecord
  belongs_to :celestial
  belongs_to :corporation
  belongs_to :graphic
  belongs_to :operation, class_name: 'StationOperation'
  belongs_to :type

  has_many :corporations_as_home_station, class_name: 'Corporation', foreign_key: :home_station_id

  has_many :services, class_name: 'StationService', through: :operation

  has_one :solar_system, through: :celestial
  has_one :constellation, through: :solar_system
  has_one :region, through: :constellation
end
