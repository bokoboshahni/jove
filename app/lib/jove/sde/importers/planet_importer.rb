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

        def import_solar_system(solar_system)
          rows = solar_system.fetch('planets', {}).map do |id, planet|
            map_planet(id, planet, solar_system)
          end

          upsert_all(rows)
        end

        private

        def map_planet(id, planet, solar_system)
          map_sde_attributes(planet, context: { id:, solar_system_id: solar_system['solarSystemID'] })
        end
      end
    end
  end
end
