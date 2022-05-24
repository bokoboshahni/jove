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
  include SDEImportable

  UNIVERSES = %w[abyssal eve void wormhole].freeze

  enum universe: UNIVERSES.each_with_object({}) { |e, h| h[e.to_sym] = e }

  self.sde_mapper = lambda { |data, context:|
    universe = context.fetch(:universe)
    data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
    data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
    data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
    data[:universe] = universe
  }

  self.sde_exclude = %i[description_id name_id]

  self.sde_rename = {
    nebula: :nebula_id,
    region_id: :id
  }

  self.sde_name_lookup = true

  has_many :constellations

  def self.import_all_from_sde
    paths = Dir[File.join(sde_path, 'fsd/universe/**/region.staticdata')]
    rows = paths.map do |path|
      universe = File.basename(File.dirname(path, 2))
      map_sde_attributes(YAML.load_file(path), context: { universe: })
    end
    upsert_all(rows)
  end
end
