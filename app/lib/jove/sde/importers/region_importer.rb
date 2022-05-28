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
            universe = File.basename(File.dirname(path, 2))
            region = map_sde_attributes(YAML.load_file(path), context: { universe: })
            progress&.advance
            region
          end
          sde_model.upsert_all(rows)
        end
      end
    end
  end
end
