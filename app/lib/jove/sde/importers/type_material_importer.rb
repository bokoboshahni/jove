# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class TypeMaterialImporter < BaseImporter
        self.sde_model = TypeMaterial

        def import_all # rubocop:disable Metrics/AbcSize
          data = YAML.load_file(File.join(sde_path, 'fsd/typeMaterials.yaml'))
          progress&.update(total: data.count)
          Parallel.each(data, in_threads: threads) do |id, orig|
            rows = orig['materials'].each_with_object([]) do |material, a|
              a << { type_id: id, material_id: material['materialTypeID'], quantity: material['quantity'] }
            end
            sde_model.upsert_all(rows, returning: false) unless rows.empty?
            progress&.advance
          end
          data
        end
      end
    end
  end
end
