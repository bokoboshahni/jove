# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StationOperationImporter < BaseImporter
        self.sde_model = StationOperation

        self.sde_exclude = %i[services station_types]

        self.sde_rename = { operation_name_id: :name_id }

        self.sde_localized = %i[description name]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          data = YAML.load_file(File.join(sde_path, 'fsd/stationOperations.yaml'))
          progress&.update(total: data.count)

          station_services = []
          station_types = []
          data.each do |operation_id, operation|
            station_services.append(*operation['services'].map { |service_id| { operation_id:, service_id: } })
            station_types.append(*operation['stationTypes']&.map do |race_id, type_id|
                                   { operation_id:, race_id:, type_id: }
                                 end)
          end
          ::StationOperationService.upsert_all(station_services.compact)
          ::StationOperationStationType.upsert_all(station_types.compact)

          rows = data.map do |id, orig|
            record = map_sde_attributes(orig, id:)
            progress&.advance
            record
          end
          sde_model.upsert_all(rows)
        end
      end
    end
  end
end
