# frozen_string_literal: true

# ## Schema Information
#
# Table name: `regions`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`center_x`**           | `decimal(, )`      | `not null`
# **`center_y`**           | `decimal(, )`      | `not null`
# **`center_z`**           | `decimal(, )`      | `not null`
# **`description`**        | `text`             |
# **`max_x`**              | `decimal(, )`      | `not null`
# **`max_y`**              | `decimal(, )`      | `not null`
# **`max_z`**              | `decimal(, )`      | `not null`
# **`min_x`**              | `decimal(, )`      | `not null`
# **`min_y`**              | `decimal(, )`      | `not null`
# **`min_z`**              | `decimal(, )`      | `not null`
# **`name`**               | `text`             | `not null`
# **`universe`**           | `enum`             | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`faction_id`**         | `bigint`           |
# **`nebula_id`**          | `bigint`           |
# **`wormhole_class_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_regions_on_faction_id`:
#     * **`faction_id`**
# * `index_regions_on_nebula_id`:
#     * **`nebula_id`**
# * `index_regions_on_wormhole_class_id`:
#     * **`wormhole_class_id`**
#
class Region < ApplicationRecord
  enum universe: %i[abyssal eve void wormhole].index_with(&:to_s)

  has_many :constellations

  has_many :solar_systems, through: :constellations

  has_many :stations, through: :solar_systems
end