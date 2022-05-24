# frozen_string_literal: true

# ## Schema Information
#
# Table name: `constellations`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`center_x`**           | `decimal(, )`      | `not null`
# **`center_y`**           | `decimal(, )`      | `not null`
# **`center_z`**           | `decimal(, )`      | `not null`
# **`max_x`**              | `decimal(, )`      | `not null`
# **`max_y`**              | `decimal(, )`      | `not null`
# **`max_z`**              | `decimal(, )`      | `not null`
# **`min_x`**              | `decimal(, )`      | `not null`
# **`min_y`**              | `decimal(, )`      | `not null`
# **`min_z`**              | `decimal(, )`      | `not null`
# **`name`**               | `text`             | `not null`
# **`radius`**             | `decimal(, )`      | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`faction_id`**         | `bigint`           |
# **`region_id`**          | `bigint`           | `not null`
# **`wormhole_class_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_constellations_on_faction_id`:
#     * **`faction_id`**
# * `index_constellations_on_region_id`:
#     * **`region_id`**
# * `index_constellations_on_wormhole_class_id`:
#     * **`wormhole_class_id`**
#
class Constellation < ApplicationRecord
  include SDEImportable

  self.sde_mapper = lambda { |data, context:|
    data[:region_id] = context[:region_id]
    data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
    data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
    data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
  }

  self.sde_exclude = %i[name_id]

  self.sde_rename = { constellation_id: :id }

  self.sde_name_lookup = true

  belongs_to :region

  has_many :solar_systems

  def self.import_all_from_sde
    region_ids = map_region_ids
    paths = Dir[File.join(sde_path, 'fsd/universe/**/constellation.staticdata')]
    rows = paths.map do |path|
      region_id = region_ids.fetch(File.dirname(path, 2))
      map_sde_attributes(YAML.load_file(path), context: { region_id: })
    end
    upsert_all(rows)
  end

  def self.map_region_ids
    regions_glob = File.join(Jove.config.sde_path, 'fsd/universe/**/region.staticdata')
    Dir[regions_glob].each_with_object({}) do |path, h|
      h[File.dirname(path)] = YAML.load_file(path)['regionID']
    end
  end
end
