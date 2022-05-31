# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StarImporter < CelestialImporter
        self.sde_model = Star

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:celestial_type] = 'Star'
          data[:position_x] = 0.0
          data[:position_y] = 0.0
          data[:position_z] = 0.0

          data.merge!(data.delete(:statistics))
        }

        def import_solar_system(solar_system)
          return unless solar_system['star']

          star = solar_system['star'].merge!('solarSystemID' => solar_system['solarSystemID'])
          star = map_sde_attributes(star)
          sde_model.upsert(star)
        end
      end
    end
  end
end
