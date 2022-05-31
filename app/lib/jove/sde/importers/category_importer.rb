# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class CategoryImporter < BaseImporter
        self.sde_file = 'fsd/categoryIDs.yaml'

        self.sde_model = Category

        self.sde_localized = %i[name]
      end
    end
  end
end
