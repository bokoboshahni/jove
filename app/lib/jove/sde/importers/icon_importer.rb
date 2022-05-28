# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class IconImporter < BaseImporter
        self.sde_file = 'fsd/iconIDs.yaml'

        self.sde_model = ::Icon

        self.sde_rename = { icon_file: :file }
      end
    end
  end
end
