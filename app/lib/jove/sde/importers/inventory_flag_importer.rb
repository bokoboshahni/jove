# frozen_string_literal: true

require 'csv'

module Jove
  module SDE
    module Importers
      class InventoryFlagImporter < BaseImporter
        self.sde_file = 'bsd/invFlags.yaml'

        self.sde_model = InventoryFlag

        self.sde_rename = {
          flag_id: :id,
          flag_name: :name,
          flag_text: :text,
          order_id: :order
        }
      end
    end
  end
end
