# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class PlanetImporter < CelestialImporter
        self.sde_model = Planet

        self.sde_mapper = lambda { |data, context:|
          data[:celestial_type] = 'Planet'
          data[:id] = context[:id]
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)

          data.merge!(data.delete(:statistics))
          data.merge!(data.delete(:planet_attributes))
        }

        self.sde_exclude = %i[asteroid_belts moons npc_stations planet_name_id]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['planets']

            planets = solar_system['planets'].map do |id, planet|
              map_sde_attributes(planet, context: { id:, solar_system_id: solar_system['solarSystemID'] })
            end
            progress&.advance
            planets
          end
          sde_model.upsert_all(rows.flatten)
        end
      end
    end
  end
end
