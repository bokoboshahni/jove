# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::TypeImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:type_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/typeIDs.yaml')).keys
    end

    let(:type_dogma) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/typeDogma.yaml'))
    end

    it 'saves each type' do
      expect(importer.import_all.rows.flatten).to match_array(type_ids)
    end

    it 'saves dogma attributes for each type' do
      importer.import_all
      Type.where(id: type_dogma.keys).each do |type|
        dogma_attributes = type_dogma[type.id]['dogmaAttributes'].map do |attr|
          attr.deep_transform_keys!(&:underscore)
        end
        expect(type.dogma_attributes).to eq(dogma_attributes)
      end
    end

    it 'saves dogma effects for each type' do
      importer.import_all
      Type.where(id: type_dogma.keys).each do |type|
        dogma_effects = type_dogma[type.id]['dogmaEffects'].map do |attr|
          attr.deep_transform_keys!(&:underscore)
        end
        expect(type.dogma_effects).to eq(dogma_effects)
      end
    end
  end
end
