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
class Moon < Celestial
  self.sde_mapper = lambda { |data, context:|
    data[:celestial_type] = 'Moon'
    data[:id] = context[:id]
    data[:ancestry] = context[:planet_id].to_s
    data[:solar_system_id] = context[:solar_system_id]
    data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)

    data.merge!(data.delete(:statistics)) if data[:statistics]
    data.merge!(data.delete(:planet_attributes))
  }

  self.sde_exclude = %i[moon_name_id npc_stations]

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
    progress&.update(total: paths.count)
    rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
      solar_system = YAML.load_file(path)
      next unless solar_system['planets']

      moons = solar_system['planets'].each_with_object([]) do |(planet_id, planet), a|
        planet['moons']&.each do |id, moon|
          a << map_sde_attributes(moon,
                                  context: { id:, planet_id:, solar_system_id: solar_system['solarSystemID'] })
        end
      end

      progress&.advance
      moons
    end.flatten
    upsert_all(rows)
  end
end
