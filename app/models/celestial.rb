# frozen_string_literal: true

# ## Schema Information
#
# Table name: `celestials`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`age`**                    | `decimal(, )`      |
# **`ancestry`**               | `text`             |
# **`celestial_index`**        | `integer`          |
# **`celestial_type`**         | `enum`             | `not null`
# **`density`**                | `decimal(, )`      |
# **`eccentricity`**           | `decimal(, )`      |
# **`escape_velocity`**        | `decimal(, )`      |
# **`fragmented`**             | `boolean`          |
# **`life`**                   | `decimal(, )`      |
# **`locked`**                 | `boolean`          |
# **`luminosity`**             | `decimal(, )`      |
# **`mass_dust`**              | `decimal(, )`      |
# **`mass_gas`**               | `decimal(, )`      |
# **`name`**                   | `text`             | `not null`
# **`orbit_period`**           | `decimal(, )`      |
# **`orbit_radius`**           | `decimal(, )`      |
# **`population`**             | `boolean`          |
# **`position_x`**             | `decimal(, )`      | `not null`
# **`position_y`**             | `decimal(, )`      | `not null`
# **`position_z`**             | `decimal(, )`      | `not null`
# **`pressure`**               | `decimal(, )`      |
# **`radius`**                 | `decimal(, )`      |
# **`rotation_rate`**          | `decimal(, )`      |
# **`spectral_class`**         | `text`             |
# **`surface_gravity`**        | `decimal(, )`      |
# **`temperature`**            | `decimal(, )`      |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`effect_beacon_type_id`**  | `bigint`           |
# **`height_map_1_id`**        | `bigint`           |
# **`height_map_2_id`**        | `bigint`           |
# **`shader_preset_id`**       | `bigint`           |
# **`solar_system_id`**        | `bigint`           | `not null`
# **`type_id`**                | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_celestials_on_effect_beacon_type_id`:
#     * **`effect_beacon_type_id`**
# * `index_celestials_on_height_map_1_id`:
#     * **`height_map_1_id`**
# * `index_celestials_on_height_map_2_id`:
#     * **`height_map_2_id`**
# * `index_celestials_on_shader_preset_id`:
#     * **`shader_preset_id`**
# * `index_celestials_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_celestials_on_type_id`:
#     * **`type_id`**
#
class Celestial < ApplicationRecord
  include SDEImportable

  enum celestial_type: {
    'AsteroidBelt' => 'asteroid_belt',
    'Moon' => 'moon',
    'Planet' => 'planet',
    'SecondarySun' => 'secondary_sun',
    'Star' => 'star'
  }

  self.inheritance_column = :celestial_type

  self.sde_rename = {
    height_map1: :height_map_1_id,
    height_map2: :height_map_2_id,
    shader_preset: :shader_preset_id
  }

  self.sde_name_lookup = true

  has_ancestry

  belongs_to :solar_system
  belongs_to :type

  has_one :constellation, through: :solar_system

  has_one :region, through: :constellation

  validates :celestial_type, presence: true
end
