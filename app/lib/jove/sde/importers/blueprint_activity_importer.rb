# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class BlueprintActivityImporter < BaseImporter
        self.sde_model = BlueprintActivity

        self.sde_exclude = %i[activities blueprint_type_id]

        def import_all # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

          ::BlueprintActivity.transaction do
            sde_model.upsert_all(blueprint_activities)
            ::BlueprintActivityMaterial.upsert_all(blueprint_activity_materials)
            ::BlueprintActivityProduct.upsert_all(blueprint_activity_products)
            ::BlueprintActivitySkill.upsert_all(blueprint_activity_skills.uniq)
          end

          data.count
        end
      end
    end
  end
end
