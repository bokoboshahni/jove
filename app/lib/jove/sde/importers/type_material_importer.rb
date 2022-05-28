# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class TypeMaterialImporter < BaseImporter
        self.sde_model = TypeMaterial

        def import_all # rubocop:disable Metrics/AbcSize
          data = YAML.load_file(File.join(sde_path, 'fsd/typeMaterials.yaml'))
          progress&.update(total: data.count)
          rows = data.each_with_object([]) do |(id, orig), a|
            orig['materials'].each do |material|
              a << { type_id: id, material_id: material['materialTypeID'], quantity: material['quantity'] }
            end
            progress&.advance
          end
          sde_model.upsert_all(rows, returning: %i[type_id material_id])
        end
      end
    end
  end
end
