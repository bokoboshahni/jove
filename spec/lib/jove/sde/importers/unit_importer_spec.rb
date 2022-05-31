# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::UnitImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }

  describe '#import_all' do
    let(:unit_ids) do
      JSON.parse(File.read(Rails.root.join('db/units.json'))).keys.map(&:to_i)
    end

    it 'saves each unit' do
      importer.import_all
      expect(Unit.pluck(:id)).to match_array(unit_ids)
    end
  end
end
