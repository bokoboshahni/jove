# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::GraphicImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:graphic_ids) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/graphicIDs.yaml')).keys
    end

    it 'saves each graphic' do
      importer.import_all
      expect(Graphic.pluck(:id)).to match_array(graphic_ids)
    end
  end
end
