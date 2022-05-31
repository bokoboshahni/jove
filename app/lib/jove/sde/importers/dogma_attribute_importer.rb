# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class DogmaAttributeImporter < BaseImporter
        self.sde_file = 'fsd/dogmaAttributes.yaml'
        self.sde_model = DogmaAttribute

        self.sde_exclude = %i[attribute_id]

        self.sde_rename = {
          charge_recharge_time_id: :recharge_time_attribute_id,
          data_type: :data_type_id
        }

        self.sde_localized = %i[display_name tooltip_description tooltip_title]
      end
    end
  end
end
