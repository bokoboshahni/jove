# frozen_string_literal: true

require 'csv'

module Jove
  module SDE
    module Importers
      class UnitImporter < BaseImporter
        self.sde_file = Rails.root.join('db/units.json')

        self.sde_model = Unit

        self.sde_multisearchable = false
      end
    end
  end
end
