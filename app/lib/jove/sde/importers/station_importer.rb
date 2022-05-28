# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StationImporter < BaseImporter
        self.sde_model = Station

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

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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
          sde_model.upsert_all(rows)
        end
      end
    end
  end
end
