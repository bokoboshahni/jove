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

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['stargates']

            stargates = solar_system['stargates'].map do |id, stargate|
              map_sde_attributes(stargate, context: { id:, solar_system_id: solar_system['solarSystemID'] })
            end
            progress&.advance
            stargates
          end
          sde_model.upsert_all(rows.flatten)
        end
      end
    end
  end
end
