# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::PlanetSchematicImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:schematic_data) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/planetSchematics.yaml'))
    end

    let(:schematic_ids) { schematic_data.keys }

    let(:schematic_input_ids) do
      schematic_data.each_with_object([]) do |(schematic_id, schematic), a|
        schematic['types'].select { |_, type| type['isInput'] }.map(&:first).each do |input_id|
          a << [schematic_id, input_id]
        end
      end
    end

    let(:schematic_pin_ids) do
      schematic_data.each_with_object([]) do |(schematic_id, schematic), a|
        schematic['pins'].each { |p| a << [schematic_id, p] }
      end
    end

    before { importer.import_all }

    it 'saves each planet schematic' do
      expect(PlanetSchematic.pluck(:id)).to match_array(schematic_ids)
    end

    it 'saves each planet schematic input' do
      expect(PlanetSchematicInput.pluck(:schematic_id, :type_id))
        .to match_array(schematic_input_ids)
    end

    it 'saves each planet schematic pin' do
      expect(PlanetSchematicPin.pluck(:schematic_id, :type_id))
        .to match_array(schematic_pin_ids)
    end
  end
end
