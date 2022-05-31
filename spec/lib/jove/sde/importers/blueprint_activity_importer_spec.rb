# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jove::SDE::Importers::BlueprintActivityImporter, type: :lib do
  subject(:importer) { described_class.new(sde_path: Rails.root.join('spec/fixtures/sde')) }
  describe '#import_all' do
    let(:blueprint_data) do
      YAML.load_file(Rails.root.join('spec/fixtures/sde/fsd/blueprints.yaml'))
    end

    let(:blueprint_activity_ids) do
      blueprint_data.each_with_object([]) do |(blueprint_id, bp), a|
        bp['activities'].each_key do |activity|
          a << [blueprint_id, activity]
        end
      end
    end

    let(:blueprint_activity_material_ids) do
      blueprint_data.each_with_object([]) do |(blueprint_id, bp), a|
        bp['activities'].each do |activity_name, activity|
          activity['materials']&.each { |m| a << [blueprint_id, activity_name, m['typeID']] }
        end
      end
    end

    let(:blueprint_activity_product_ids) do
      blueprint_data.each_with_object([]) do |(blueprint_id, bp), a|
        bp['activities'].each do |activity_name, activity|
          activity['products']&.each { |p| a << [blueprint_id, activity_name, p['typeID']] }
        end
      end
    end

    let(:blueprint_activity_skill_ids) do
      blueprint_data.each_with_object([]) do |(blueprint_id, bp), a|
        bp['activities'].each do |activity_name, activity|
          activity['skills']&.each { |s| a << [blueprint_id, activity_name, s['typeID']] }
        end
      end
    end

    it 'saves each blueprint activity' do
      importer.import_all
      expect(BlueprintActivity.pluck(:blueprint_id, :activity)).to match_array(blueprint_activity_ids)
    end

    it 'saves each blueprint activity material' do
      importer.import_all
      expect(BlueprintActivityMaterial.pluck(:blueprint_id, :activity, :material_id))
        .to match_array(blueprint_activity_material_ids)
    end

    it 'saves each blueprint activity product' do
      importer.import_all
      expect(BlueprintActivityProduct.pluck(:blueprint_id, :activity, :product_id))
        .to match_array(blueprint_activity_product_ids)
    end

    it 'saves each blueprint activity material' do
      importer.import_all
      expect(BlueprintActivitySkill.pluck(:blueprint_id, :activity, :skill_id))
        .to match_array(blueprint_activity_skill_ids)
    end
  end
end
