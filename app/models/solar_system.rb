# frozen_string_literal: true

# ## Schema Information
#
# Table name: `solar_systems`
#
# ### Columns
#
# Name                                | Type               | Attributes
# ----------------------------------- | ------------------ | ---------------------------
# **`id`**                            | `bigint`           | `not null, primary key`
# **`border`**                        | `boolean`          | `not null`
# **`center_x`**                      | `decimal(, )`      | `not null`
# **`center_y`**                      | `decimal(, )`      | `not null`
# **`center_z`**                      | `decimal(, )`      | `not null`
# **`corridor`**                      | `boolean`          | `not null`
# **`disallowed_anchor_categories`**  | `integer`          | `is an Array`
# **`disallowed_anchor_groups`**      | `integer`          | `is an Array`
# **`fringe`**                        | `boolean`          | `not null`
# **`hub`**                           | `boolean`          | `not null`
# **`international`**                 | `boolean`          | `not null`
# **`log_data`**                      | `jsonb`            |
# **`luminosity`**                    | `decimal(, )`      | `not null`
# **`max_x`**                         | `decimal(, )`      | `not null`
# **`max_y`**                         | `decimal(, )`      | `not null`
# **`max_z`**                         | `decimal(, )`      | `not null`
# **`min_x`**                         | `decimal(, )`      | `not null`
# **`min_y`**                         | `decimal(, )`      | `not null`
# **`min_z`**                         | `decimal(, )`      | `not null`
# **`name`**                          | `text`             | `not null`
# **`radius`**                        | `decimal(, )`      | `not null`
# **`regional`**                      | `boolean`          | `not null`
# **`security`**                      | `decimal(, )`      | `not null`
# **`security_class`**                | `text`             |
# **`visual_effect`**                 | `text`             |
# **`created_at`**                    | `datetime`         | `not null`
# **`updated_at`**                    | `datetime`         | `not null`
# **`constellation_id`**              | `bigint`           | `not null`
# **`faction_id`**                    | `bigint`           |
# **`wormhole_class_id`**             | `bigint`           |
#
# ### Indexes
#
# * `index_solar_systems_on_constellation_id`:
#     * **`constellation_id`**
# * `index_solar_systems_on_faction_id`:
#     * **`faction_id`**
# * `index_solar_systems_on_wormhole_class_id`:
#     * **`wormhole_class_id`**
#
class SolarSystem < ApplicationRecord
  include SDEImportable

  belongs_to :constellation

  has_many :celestials

  has_many :stations, through: :celestials

  has_one :region, through: :constellation
end
