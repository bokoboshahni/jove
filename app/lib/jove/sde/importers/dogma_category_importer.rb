# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class DogmaCategoryImporter < BaseImporter
        self.sde_file = 'fsd/dogmaAttributeCategories.yaml'
        self.sde_model = DogmaCategory
      end
    end
  end
end
