# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StarImporter < CelestialImporter
        self.sde_model = Star

        self.sde_mapper = lambda { |data, context:|
          data[:celestial_type] = 'Star'
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x] = 0.0
          data[:position_y] = 0.0
          data[:position_z] = 0.0

          data.merge!(data.delete(:statistics))
        }

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['star']

            stars = map_sde_attributes(solar_system['star'],
                                       context: { solar_system_id: solar_system['solarSystemID'] })
            progress&.advance
            stars
          end.compact
          sde_model.upsert_all(rows.flatten)
        end
      end
    end
  end
end
