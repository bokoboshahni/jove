# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::StationServiceImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:service_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/stationServices.yaml')).keys
    end

    it 'saves each station service' do
      importer.import_all
      expect(StationService.pluck(:id)).to match_array(service_ids)
    end
  end
end
