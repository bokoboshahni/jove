# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::MarketGroupImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:market_group_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/marketGroups.yaml')).keys
    end

    it 'saves each market group' do
      importer.import_all
      expect(MarketGroup.pluck(:id)).to match_array(market_group_ids)
    end

    it 'builds ancestry' do
      importer.import_all
      expect(MarketGroup.find(1016).ancestry).to eq('2/211')
    end
  end
end
