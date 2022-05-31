# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class GroupImporter < BaseImporter
        self.sde_file = 'fsd/groupIDs.yaml'

        self.sde_model = Group

        self.sde_localized = %i[name]
      end
    end
  end
end
