# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class BloodlineImporter < BaseImporter
        self.sde_file = 'fsd/bloodlines.yaml'

        self.sde_model = Bloodline

        self.sde_localized = %i[description name]
      end
    end
  end
end
