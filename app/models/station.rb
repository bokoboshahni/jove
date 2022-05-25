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
  include SDEImportable

  self.sde_exclude = %i[
    constellation_id
    owner_id
    position
    region_id
    security
    solar_system_id
    station_id
    station_type_id
  ]

  self.sde_rename = {
    is_conquerable: :conquerable,
    reprocessing_hangar_flag: :reprocessing_hangar_flag_id,
    reprocessing_stations_take: :reprocessing_station_take,
    station_name: :name,
    x: :position_x,
    y: :position_y,
    z: :position_z
  }

  belongs_to :celestial
  belongs_to :corporation
  belongs_to :graphic
  belongs_to :operation, class_name: 'StationOperation'
  belongs_to :type

  has_many :corporations_as_home_station, class_name: 'Corporation', foreign_key: :home_station_id

  has_one :solar_system, through: :celestial
  has_one :constellation, through: :solar_system
  has_one :region, through: :constellation

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    bsd_data = YAML.load_file(File.join(sde_path, 'bsd/staStations.yaml'))
    fsd_paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
    fsd_data = Parallel.map(fsd_paths, in_threads: Etc.nprocessors) do |path|
      solar_system = YAML.load_file(path)
      solar_system['planets']&.each_with_object({}) do |(planet_id, planet), h|
        if planet['npcStations']
          h.merge!(planet['npcStations'].transform_values do |s|
                     s.merge('celestialID' => planet_id)
                   end)
        end
        planet['moons']&.each do |moon_id, moon|
          next unless moon['npcStations']

          h.merge!(moon['npcStations'].transform_values { |s| s.merge('celestialID' => moon_id) })
        end
      end
    end.reduce(&:merge)
    data = bsd_data.each_with_object({}) do |s, h|
      id = s['stationID']
      h[id] = s.merge(fsd_data.fetch(id))
    end

    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
