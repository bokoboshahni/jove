# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class PlanetSchematicImporter < BaseImporter
        self.sde_model = PlanetSchematic

        self.sde_mapper = lambda { |data, **_kwargs|
          data[:time] = data.delete(:cycle_time).seconds
          output_id, output = data[:types].find { |_type_id, type| !type[:is_input] }
          data[:output_id] = output_id
          data[:output_quantity] = output[:quantity]
        }

        self.sde_exclude = %i[types]

        self.sde_localized = %i[name]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
          data = YAML.load_file(File.join(sde_path, 'fsd/planetSchematics.yaml'))
          progress&.update(total: data.count)

          inputs = []
          pins = []

          data.each do |schematic_id, schematic|
            schematic['pins'].each { |type_id| pins << { schematic_id:, type_id: } }
            schematic['types'].select { |_, t| t['isInput'] }.each do |type_id, input|
              inputs << { schematic_id:, type_id:, quantity: input['quantity'] }
            end
          end

          rows = data.map do |id, orig|
            record = map_sde_attributes(orig, id:)
            progress&.advance
            record
          end

          PlanetSchematic.transaction do
            PlanetSchematicInput.upsert_all(inputs)
            PlanetSchematicPin.upsert_all(pins)
            sde_model.upsert_all(rows)
          end
        end
      end
    end
  end
end
