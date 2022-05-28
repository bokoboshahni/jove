# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class AsteroidBeltImporter < CelestialImporter
        self.sde_model = AsteroidBelt

        self.sde_mapper = lambda { |data, context:|
          data[:celestial_type] = 'AsteroidBelt'
          data[:id] = context[:id]
          data[:ancestry] = context[:planet_id].to_s
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)

          data.merge!(data.delete(:statistics)) if data[:statistics]
        }

        self.sde_exclude = %i[asteroid_belt_name_id]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['planets']

            belts = solar_system['planets'].each_with_object([]) do |(planet_id, planet), a|
              planet['asteroidBelts']&.each do |id, belt|
                a << map_sde_attributes(belt,
                                        context: { id:, planet_id:,
                                                   solar_system_id: solar_system['solarSystemID'] })
              end
            end

            progress&.advance
            belts
          end.flatten
          sde_model.upsert_all(rows.flatten)
        end
      end
    end
  end
end
