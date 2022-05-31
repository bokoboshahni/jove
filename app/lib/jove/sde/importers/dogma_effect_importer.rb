# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class DogmaEffectImporter < BaseImporter
        self.sde_file = 'fsd/dogmaEffects.yaml'
        self.sde_model = DogmaEffect

        self.sde_exclude = %i[modifier_info effect_id]

        self.sde_rename = {
          charge_recharge_time_id: :recharge_time_attribute_id,
          data_type: :data_type_id,
          effect_category: :category_id,
          effect_name: :name
        }

        self.sde_localized = %i[description display_name]
      end
    end
  end
end
