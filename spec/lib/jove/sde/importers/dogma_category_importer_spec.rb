# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::DogmaCategoryImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:dogma_category_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/dogmaAttributeCategories.yaml')).keys
    end

    it 'saves each dogma category' do
      importer.import_all
      expect(DogmaCategory.pluck(:id)).to match_array(dogma_category_ids)
    end
  end
end
