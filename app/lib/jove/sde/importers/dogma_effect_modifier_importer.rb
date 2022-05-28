# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class DogmaEffectModifierImporter < BaseImporter
        self.sde_model = DogmaEffectModifier

        self.sde_rename = {
          func: :function,
          effect_id: :modified_effect_id,
          operation: :operation_id,
          skill_type_id: :skill_id
        }

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          data = YAML.load_file(File.join(sde_path, 'fsd/dogmaEffects.yaml'))
          progress&.update(total: data.count)
          rows = data.each_with_object([]) do |(id, orig), a|
            orig['modifierInfo']&.each do |modifier|
              a << map_sde_attributes(modifier, id: SecureRandom.uuid).merge!(effect_id: id)
            end

            progress&.advance
          end

          DogmaEffectModifier.transaction do
            ::DogmaEffectModifier.delete_all
            sde_model.upsert_all(rows)
          end
        end
      end
    end
  end
end
