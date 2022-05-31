# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class TypeMaterialImporter < BaseImporter
        self.sde_model = TypeMaterial

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/typeMaterials.yaml'))
          start_progress(total: data.count)
          Parallel.each(data, in_threads: threads) do |id, orig|
            rows = orig['materials'].each_with_object([]) do |material, a|
              a << { type_id: id, material_id: material['materialTypeID'], quantity: material['quantity'] }
            end
            upsert_all(rows)
            advance_progress
          end
          data
        end
      end
    end
  end
end
