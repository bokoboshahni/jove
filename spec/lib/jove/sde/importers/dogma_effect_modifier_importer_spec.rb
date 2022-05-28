# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::DogmaEffectModifierImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:dogma_effect_modifiers) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/dogmaEffects.yaml')).values.map do |e|
        e['modifierInfo']
      end.flatten.compact
    end

    it 'saves each dogma effect modifier' do
      expect(importer.import_all.rows.count).to eq(dogma_effect_modifiers.count)
    end
  end
end
