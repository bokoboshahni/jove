# frozen_string_literal: true

module Jove
  module SDE
    module Importers
      class BlueprintActivityImporter < BaseImporter
        self.sde_model = BlueprintActivity

        def import_all
          data = YAML.load_file(File.join(sde_path, 'fsd/blueprints.yaml'))
          progress&.update(total: data.count)
          Parallel.each(data, in_threads: threads) do |id, orig|
            activities, materials, products, skills = map_activities(id, orig['activities'])
            upsert_blueprint_activities(activities, materials, products, skills)
            progress&.advance
          end

          data.keys
        end

        def map_activities(blueprint_id, orig_activities) # rubocop:disable Metrics/MethodLength
          activities = []
          materials = []
          products = []
          skills = []
          orig_activities.each do |activity_type, activity|
            key = { blueprint_id:, activity: activity_type.to_sym }
            activities << { time: activity['time'].seconds }.merge!(key)
            map_materials(activity['materials'], key, materials)
            map_products(activity['products'], key, products)
            map_skills(activity['skills'], key, skills)
          end
          [activities, materials, products, skills]
        end

        def map_materials(materials, key, rows)
          materials&.each do |material|
            row = { quantity: material['quantity'], material_id: material['typeID'] }.merge!(key)
            next if rows.include?(row)

            rows << row
          end
        end

        def map_products(products, key, rows)
          products&.each do |product|
            row = { probability: product['probability'], quantity: product['quantity'],
                    product_id: product['typeID'] }.merge!(key)
            next if rows.include?(row)

            rows << row
          end
        end

        def map_skills(skills, key, rows)
          skills&.each do |skill|
            row = { level: skill['level'], skill_id: skill['typeID'] }.merge!(key)
            next if rows.include?(row)

            rows << row
          end
        end

        def upsert_blueprint_activities(activities, materials, products, skills)
          sde_model.transaction do
            BlueprintActivityMaterial.upsert_all(materials) unless materials.empty?
            BlueprintActivityProduct.upsert_all(products) unless products.empty?
            BlueprintActivitySkill.upsert_all(skills.uniq) unless skills.empty?
            sde_model.upsert_all(activities, returning: false) unless activities.empty?
          end
        end
      end
    end
  end
end
