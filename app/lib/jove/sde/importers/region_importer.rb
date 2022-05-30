# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class RegionImporter < BaseImporter
        self.sde_model = Region

        self.sde_mapper = lambda { |data, context:|
          universe = context.fetch(:universe)
          data[:center_x], data[:center_y], data[:center_z] = data.delete(:center)
          data[:max_x], data[:max_y], data[:max_z] = data.delete(:max)
          data[:min_x], data[:min_y], data[:min_z] = data.delete(:min)
          data[:universe] = universe
        }

        self.sde_exclude = %i[description_id name_id]

        self.sde_rename = {
          nebula: :nebula_id,
          region_id: :id
        }

        self.sde_name_lookup = true

        def import_all
          paths = Dir[File.join(sde_path, 'fsd/universe/**/region.staticdata')]
          progress&.update(total: paths.count)
          rows = paths.map do |path|
            universe = universe_from_path(path)
            region = map_region(YAML.load_file(path), universe)
            progress&.advance
            region
          end
          sde_model.upsert_all(rows, returning: false) unless rows.empty?
        end

        private

        def map_region(region, universe)
          map_sde_attributes(region, context: { universe: })
        end

        def universe_from_path(path)
          File.basename(File.dirname(path, 2))
        end
      end
    end
  end
end
