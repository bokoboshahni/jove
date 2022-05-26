# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`time`**          | `interval`         | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activities_on_blueprint_id`:
#     * **`blueprint_id`**
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#
require 'rails_helper'

RSpec.describe BlueprintActivity, type: :model do
  describe '.import_all_from_sde' do
    let(:blueprint_data) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/blueprints.yaml'))
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

    before { described_class.import_all_from_sde }

    it 'saves each blueprint activity' do
      expect(described_class.pluck(:blueprint_id, :activity)).to match_array(blueprint_activity_ids)
    end

    it 'saves each blueprint activity material' do
      expect(BlueprintActivityMaterial.pluck(:blueprint_id, :activity, :material_id))
        .to match_array(blueprint_activity_material_ids)
    end

    it 'saves each blueprint activity product' do
      expect(BlueprintActivityProduct.pluck(:blueprint_id, :activity, :product_id))
        .to match_array(blueprint_activity_product_ids)
    end

    it 'saves each blueprint activity material' do
      expect(BlueprintActivitySkill.pluck(:blueprint_id, :activity, :skill_id))
        .to match_array(blueprint_activity_skill_ids)
    end
  end
end
