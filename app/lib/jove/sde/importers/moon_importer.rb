# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class MoonImporter < CelestialImporter
        self.sde_model = Moon

        self.sde_mapper = lambda { |data, context:|
          data[:celestial_type] = 'Moon'
          data[:id] = context[:id]
          data[:ancestry] = context[:planet_id].to_s
          data[:solar_system_id] = context[:solar_system_id]
          data[:position_x], data[:position_y], data[:position_z] = data.delete(:position)

          data.merge!(data.delete(:statistics)) if data[:statistics]
          data.merge!(data.delete(:planet_attributes))
        }

        self.sde_exclude = %i[moon_name_id npc_stations]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors) do |path|
            solar_system = YAML.load_file(path)
            next unless solar_system['planets']

            moons = solar_system['planets'].each_with_object([]) do |(planet_id, planet), a|
              planet['moons']&.each do |id, moon|
                a << map_sde_attributes(moon,
                                        context: { id:, planet_id:, solar_system_id: solar_system['solarSystemID'] })
              end
            end

            progress&.advance
            moons
          end.flatten
          sde_model.upsert_all(rows)
        end
      end
    end
  end
end
