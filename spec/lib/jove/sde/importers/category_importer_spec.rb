# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::CategoryImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:category_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/categoryIDs.yaml')).keys
    end

    it 'saves each category' do
      importer.import_all
      expect(Category.pluck(:id)).to match_array(category_ids)
    end
  end
end
