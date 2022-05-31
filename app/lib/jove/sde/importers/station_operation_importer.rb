# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class StationOperationImporter < BaseImporter
        self.sde_model = StationOperation

        self.sde_exclude = %i[services station_types]

        self.sde_rename = { operation_name_id: :name_id }

        self.sde_localized = %i[description name]

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/stationOperations.yaml'))
          start_progress(total: data.count)
          data.each do |operation_id, operation|
            services = map_services(operation_id, operation['services'])
            types = map_types(operation_id, operation['stationTypes'])
            upsert_operation(operation_id, operation, services, types)
            advance_progress
          end
        end

        private

        def upsert_operation(operation_id, operation, services, types)
          sde_model.transaction do
            StationOperationService.upsert_all(services) unless services.empty?
            StationOperationStationType.upsert_all(types) unless types.empty?
            sde_model.upsert(map_sde_attributes(operation, id: operation_id), returning: false)
          end
        end

        def map_services(operation_id, services)
          (services || []).map { |service_id| { operation_id:, service_id: } }
        end

        def map_types(operation_id, types)
          (types || {}).map { |race_id, type_id| { operation_id:, race_id:, type_id: } }
        end
      end
    end
  end
end
