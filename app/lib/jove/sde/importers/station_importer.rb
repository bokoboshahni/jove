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
          station_type_id
        ]

        self.sde_rename = {
          is_conquerable: :conquerable,
          reprocessing_hangar_flag: :reprocessing_hangar_flag_id,
          reprocessing_stations_take: :reprocessing_station_take,
          station_id: :id,
          station_name: :name,
          x: :position_x,
          y: :position_y,
          z: :position_z
        }

        def initialize(**kwargs)
          super(**kwargs)

          @bsd_data = YAML.load_file(File.join(sde_path, 'bsd/staStations.yaml')).each_with_object({}) do |s, h|
            h[s['stationID']] = s
          end
        end

        def import_solar_system(solar_system)
          rows = solar_system.fetch('planets', {}).each_with_object([]) do |(planet_id, planet), a|
            map_celestial_stations(planet_id, planet, a)
            planet['moons']&.each { |m_id, m| map_celestial_stations(m_id, m, a) }
          end

          upsert_all(rows)
        end

        private

        attr_reader :bsd_data

        def map_celestial_stations(celestial_id, celestial, stations)
          celestial['npcStations']&.each do |station_id, station|
            stations << map_station_attributes(station_id, station, celestial_id)
          end
        end

        def map_station_attributes(station_id, station, celestial_id)
          map_sde_attributes(station.merge!(bsd_data.fetch(station_id)).merge!('celestialID' => celestial_id))
        end
      end
    end
  end
end
