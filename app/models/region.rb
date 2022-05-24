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

  def self.import_all_from_sde
    paths = Dir[File.join(sde_path, 'fsd/universe/**/region.staticdata')]
    rows = paths.map do |path|
      universe = File.basename(File.dirname(path, 2))
      load_from_sde(File.basename(File.dirname(path)), universe:)
    end
    upsert_all(rows)
  end

  def self.import_from_sde(sde_name, universe: :eve)
    data = load_from_sde(sde_name, universe:)
    create_with(data).find_or_create_by(id: data[:id])
  end

  def self.load_from_sde(sde_name, universe: :eve)
    path = File.join(sde_path, "fsd/universe/#{universe}/#{sde_name}/region.staticdata")
    map_sde(YAML.load_file(path), universe:)
  end

  def self.map_sde(data, universe: :eve)
    map_sde_attributes(data, context: { universe: })
  end
end
