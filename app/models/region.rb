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
# **`log_data`**           | `jsonb`            |
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
  include SDEImportable
  include Searchable

  JOVE_REGIONS = [10_000_004, 10_000_017, 10_000_019].freeze

  multisearchable against: %i[name]

  pg_search_scope :search_by_name, against: %i[name], using: { tsearch: { prefix: true } }

  enum universe: %i[abyssal eve void wormhole].index_with(&:to_s)

  has_one :market_location, as: :location

  has_one :market_order_source, as: :source

  has_one :market, through: :market_location

  has_many :constellations

  has_many :solar_systems, through: :constellations

  has_many :stations, through: :solar_systems
  has_many :structures, through: :solar_systems

  scope :eve, -> { where(universe: :eve).where.not(id: JOVE_REGIONS) }
end
