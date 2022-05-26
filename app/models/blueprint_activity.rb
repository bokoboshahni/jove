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
class BlueprintActivity < ApplicationRecord
  include BlueprintActivityEnum
  include SDEImportable

  self.primary_keys = :blueprint_id, :activity

  self.sde_exclude = %i[activities blueprint_type_id]

  belongs_to :blueprint, class_name: 'Type'

  has_many :materials, class_name: 'BlueprintActivityMaterial',
                       foreign_key: %i[blueprint_id activity]
  has_many :products, class_name: 'BlueprintActivityProduct',
                      foreign_key: %i[blueprint_id activity]
  has_many :skills, class_name: 'BlueprintActivitySkill',
                    foreign_key: %i[blueprint_id activity]

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    data = YAML.load_file(File.join(sde_path, 'fsd/blueprints.yaml'))
    progress&.update(total: data.count)

    blueprint_activities = []
    blueprint_activity_materials = []
    blueprint_activity_products = []
    blueprint_activity_skills = []

    data.each do |id, orig|
      orig['activities'].each do |activity_type, activity|
        key = { blueprint_id: id, activity: activity_type.to_sym }
        blueprint_activities << { time: activity['time'].seconds }.merge(key)

        activity['materials']&.each do |material|
          row = { quantity: material['quantity'], material_id: material['typeID'] }.merge(key)
          next if blueprint_activity_materials.include?(row)

          blueprint_activity_materials << row
        end

        activity['skills']&.each do |skill|
          row = { level: skill['level'], skill_id: skill['typeID'] }.merge(key)
          next if blueprint_activity_skills.include?(row)

          blueprint_activity_skills << row
        end

        activity['products']&.each do |product|
          row = { probability: product['probability'], quantity: product['quantity'],
                  product_id: product['typeID'] }.merge(key)
          next if blueprint_activity_products.include?(row)

          blueprint_activity_products << row
        end
      end

      progress&.advance
    end

    BlueprintActivity.transaction do
      BlueprintActivity.upsert_all(blueprint_activities)
      BlueprintActivityMaterial.upsert_all(blueprint_activity_materials)
      BlueprintActivityProduct.upsert_all(blueprint_activity_products)
      BlueprintActivitySkill.upsert_all(blueprint_activity_skills.uniq)
    end

    data.count
  end
end
