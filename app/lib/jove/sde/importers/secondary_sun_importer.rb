# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class SecondarySunImporter < CelestialImporter
        self.sde_model = SecondarySun

        self.sde_mapper = lambda { |data, context:|
          data[:id] = data.delete(:item_id)
          data[:celestial_type] = 'SecondarySun'
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)
        }

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['secondarySun']

            suns = map_sde_attributes(solar_system['secondarySun'],
                                      context: { solar_system_id: solar_system['solarSystemID'] })
            progress&.advance
            suns
          end.compact
          sde_model.upsert_all(rows.flatten)
        end
      end
    end
  end
end
