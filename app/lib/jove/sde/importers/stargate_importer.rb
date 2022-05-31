# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StargateImporter < BaseImporter
        self.sde_model = Stargate

        self.sde_mapper = lambda { |data, context:|
          data[:id] = context[:id]
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)
        }

        self.sde_name_lookup = true

        self.sde_rename = { destination: :destination_id }

        def import_solar_system(solar_system)
          rows = solar_system.fetch('stargates', {}).map do |id, stargate|
            map_stargate(id, stargate, solar_system)
          end

          upsert_all(rows)
        end

        private

        def map_stargate(id, stargate, solar_system)
          map_sde_attributes(stargate, context: { id:, solar_system_id: solar_system['solarSystemID'] })
        end
      end
    end
  end
end
