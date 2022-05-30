# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::DogmaEffectImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:dogma_effect_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/dogmaEffects.yaml')).keys
    end

    it 'saves each dogma effect' do
      importer.import_all
      expect(DogmaEffect.pluck(:id)).to match_array(dogma_effect_ids)
    end
  end
end
