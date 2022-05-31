# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StationServiceImporter < BaseImporter
        self.sde_file = 'fsd/stationServices.yaml'

        self.sde_model = StationService

        self.sde_rename = { service_name_id: :name_id }

        self.sde_localized = %i[description name]
      end
    end
  end
end
