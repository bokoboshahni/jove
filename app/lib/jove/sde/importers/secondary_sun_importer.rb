# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class SecondarySunImporter < CelestialImporter
        self.sde_model = SecondarySun

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:id] = data.delete(:item_id)
          data[:celestial_type] = 'SecondarySun'
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)
        }

        def import_solar_system(solar_system)
          return unless solar_system['secondarySun']

          sun = solar_system['secondarySun'].merge!('solarSystemID' => solar_system['solarSystemID'])
          sun = map_sde_attributes(sun)
          sde_model.upsert(sun)
        end
      end
    end
  end
end
