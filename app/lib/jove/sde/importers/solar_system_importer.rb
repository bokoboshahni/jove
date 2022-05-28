# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class SolarSystemImporter < BaseImporter
        self.sde_model = SolarSystem

        self.sde_mapper = lambda { |data, context:|
          data[:constellation_id] = context[:constellation_id]
          data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
          data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
          data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
        }

        self.sde_exclude = %i[description_id planets secondary_sun solar_system_name_id star stargates sun_type_id]

        self.sde_rename = { solar_system_id: :id }

        self.sde_name_lookup = true

        def import_all # rubocop:disable Metrics/AbcSize
          constellation_ids = map_constellation_ids
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          progress&.update(total: paths.count)
          rows = Parallel.map(paths, in_threads: Etc.nprocessors * 2) do |path|
            constellation_id = constellation_ids.fetch(File.dirname(path, 2))
            solar_systems = map_sde_attributes(YAML.load_file(path), context: { constellation_id: })
            progress&.advance
            solar_systems
          end
          sde_model.upsert_all(rows)
        end

        def map_constellation_ids
          constellations_glob = File.join(sde_path, 'fsd/universe/**/constellation.staticdata')
          Dir[constellations_glob].each_with_object({}) do |path, h|
            h[File.dirname(path)] = YAML.load_file(path)['constellationID']
          end
        end
      end
    end
  end
end
