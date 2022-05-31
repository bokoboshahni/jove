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

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/planetSchematics.yaml'))
          start_progress(total: data.count)
          data.each do |schematic_id, schematic|
            inputs = map_inputs(schematic_id, schematic['types'])
            pins = map_pins(schematic_id, schematic['pins'])
            upsert_schematic(schematic_id, schematic, inputs, pins)
            advance_progress
          end
          rebuild_multisearch_index
        end

        private

        def upsert_schematic(schematic_id, schematic, inputs, pins)
          sde_model.transaction do
            PlanetSchematicInput.upsert_all(inputs) unless inputs.empty?
            PlanetSchematicPin.upsert_all(pins) unless pins.empty?
            sde_model.upsert(map_sde_attributes(schematic, id: schematic_id), returning: false)
          end
        end

        def map_inputs(schematic_id, inputs)
          inputs.select { |_, t| t['isInput'] }.map do |type_id, input|
            { schematic_id:, type_id:, quantity: input['quantity'] }
          end
        end

        def map_pins(schematic_id, pins)
          pins.map { |type_id| { schematic_id:, type_id: } }
        end
      end
    end
  end
end
