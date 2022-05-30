# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::FactionImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:faction_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/factions.yaml')).keys
    end

    it 'saves each faction' do
      importer.import_all
      expect(Faction.pluck(:id)).to match_array(faction_ids)
    end
  end
end
