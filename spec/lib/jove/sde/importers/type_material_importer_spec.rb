# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::TypeMaterialImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:type_material_ids) do
      fixture = Rails.root.join('spec/fixtures/sde/fsd/typeMaterials.yaml')
      YAML.load_file(fixture).each_with_object([]) do |(id, type), a|
        type['materials'].each { |m| a << [id, m['materialTypeID']] }
      end
    end

    it 'saves each type material' do
      expect(importer.import_all.rows).to match_array(type_material_ids)
    end
  end
end
