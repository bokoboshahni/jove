# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::RaceImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:race_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/races.yaml')).keys
    end

    it 'saves each race' do
      expect(importer.import_all.rows.flatten).to match_array(race_ids)
    end
  end
end
