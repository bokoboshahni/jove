# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class SolarSystemImporter < BaseImporter
        self.sde_model = SolarSystem

        self.sde_multisearch_models = [Celestial, Stargate, Station, SolarSystem].freeze

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
          data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
          data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
        }

        self.sde_exclude = %i[description_id planets secondary_sun solar_system_name_id star stargates sun_type_id]

        self.sde_rename = { solar_system_id: :id }

        self.sde_name_lookup = true

        def initialize(**kwargs)
          super(**kwargs)

          @constellation_ids = map_constellation_ids
        end

        def import_all
          paths = Dir[File.join(sde_path, 'fsd/universe/**/solarsystem.staticdata')]
          start_progress(total: paths.count)
          Parallel.each(paths, in_threads: threads) do |path|
            solar_system = load_solar_system(path)
            child_importers.each { |i| i.import_solar_system(solar_system) }
            sde_model.upsert(map_sde_attributes(solar_system))
            advance_progress
          end
          rebuild_multisearch_index
          paths
        end

        private

        CHILD_IMPORTERS = [PlanetImporter, MoonImporter, AsteroidBeltImporter, StarImporter, StargateImporter,
                           SecondarySunImporter, StationImporter].freeze

        attr_reader :constellation_ids

        def load_solar_system(path)
          solar_system = YAML.load_file(path)
          solar_system['constellationID'] = constellation_ids.fetch(File.dirname(path, 2))
          solar_system
        end

        def child_importers
          @child_importers ||= CHILD_IMPORTERS.map { |i| i.new(sde_path:, threads:) }
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
