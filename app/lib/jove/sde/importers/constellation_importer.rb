# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class ConstellationImporter < BaseImporter
        self.sde_model = Constellation

        self.sde_mapper = lambda { |data, context:|
          data[:region_id] = context[:region_id]
          data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
          data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
          data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
        }

        self.sde_exclude = %i[name_id]

        self.sde_rename = { constellation_id: :id }

        self.sde_name_lookup = true

        def import_all # rubocop:disable Metrics/AbcSize
          region_ids = map_region_ids
          paths = Dir[File.join(sde_path, 'fsd/universe/**/constellation.staticdata')]
          progress&.update(total: paths.count)
          rows = paths.map do |path|
            region_id = region_ids.fetch(File.dirname(path, 2))
            constellation = map_sde_attributes(YAML.load_file(path), context: { region_id: })
            progress&.advance
            constellation
          end
          sde_model.upsert_all(rows, returning: false) unless rows.empty?
        end

        def map_region_ids
          regions_glob = File.join(sde_path, 'fsd/universe/**/region.staticdata')
          Dir[regions_glob].each_with_object({}) do |path, h|
            h[File.dirname(path)] = YAML.load_file(path)['regionID']
          end
        end
      end
    end
  end
end
