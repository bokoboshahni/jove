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

  self.sde_mapper = lambda { |data, context:|
    data[:constellation_id] = context[:constellation_id]
    data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
    data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
    data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
  }

  self.sde_exclude = %i[description_id planets secondary_sun solar_system_name_id star stargates sun_type_id]

  self.sde_rename = { solar_system_id: :id }

  self.sde_name_lookup = true

  belongs_to :region

  def self.import_all_from_sde
    constellation_ids = map_constellation_ids
    paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
    rows = Parallel.map(paths, in_threads: Etc.nprocessors * 2) do |path|
      constellation_id = constellation_ids.fetch(File.dirname(path, 2))
      map_sde_attributes(YAML.load_file(path), context: { constellation_id: })
    end
    upsert_all(rows)
  end

  def self.map_constellation_ids
    constellations_glob = File.join(Jove.config.sde_path, 'fsd/universe/**/constellation.staticdata')
    Dir[constellations_glob].each_with_object({}) do |path, h|
      h[File.dirname(path)] = YAML.load_file(path)['constellationID']
    end
  end
end
