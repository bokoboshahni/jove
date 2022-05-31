# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StationOperationImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:operation_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/stationOperations.yaml')).keys
    end

    it 'saves each operation' do
      importer.import_all
      expect(StationOperation.pluck(:id)).to match_array(operation_ids)
    end
  end
end
