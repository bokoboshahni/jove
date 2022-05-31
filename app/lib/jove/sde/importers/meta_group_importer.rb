# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class MetaGroupImporter < BaseImporter
        self.sde_file = 'fsd/metaGroups.yaml'
        self.sde_model = MetaGroup

        self.sde_localized = %i[description name]
      end
    end
  end
end
