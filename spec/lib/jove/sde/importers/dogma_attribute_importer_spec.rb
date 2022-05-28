# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::DogmaAttributeImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:dogma_attribute_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/dogmaAttributes.yaml')).keys
    end

    it 'saves each dogma attribute' do
      expect(importer.import_all.rows.flatten).to match_array(dogma_attribute_ids)
    end
  end
end
