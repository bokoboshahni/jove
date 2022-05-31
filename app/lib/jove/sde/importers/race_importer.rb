# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class RaceImporter < BaseImporter
        self.sde_file = 'fsd/races.yaml'

        self.sde_model = Race

        self.sde_exclude = %i[skills]

        self.sde_localized = %i[description name]
      end
    end
  end
end
