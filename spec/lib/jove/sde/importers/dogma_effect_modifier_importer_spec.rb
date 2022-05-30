# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::DogmaEffectModifierImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_all' do
    let(:dogma_effect_modifier_ids) do
      fixture = Rails.root.join('spec/fixtures/sde/fsd/dogmaEffects.yaml')
      YAML.load_file(fixture).each_with_object([]) do |(id, e), a|
        e['modifierInfo']&.each_index { |i| a << [id, i] }
      end
    end

    it 'saves each dogma effect modifier' do
      expect(importer.import_all.rows).to eq(dogma_effect_modifier_ids)
    end
  end
end
