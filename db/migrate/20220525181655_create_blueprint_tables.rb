# frozen_string_literal: true

class CreateBlueprintTables < ActiveRecord::Migration[7.0]
  def change
    add_column :types, :max_production_limit, :integer

    create_enum :blueprint_activity, %w[copying invention manufacturing reaction research_material research_time]

    create_table :blueprint_activities, id: false, primary_key: %i[blueprint_id activity] do |t|
      t.references :blueprint, null: false

      t.enum :activity, enum_type: :blueprint_activity, null: false
      t.interval :time, null: false

      t.index %i[blueprint_id activity], unique: true, name: :index_unique_blueprint_activities
    end

    create_table :blueprint_activity_materials, id: false, primary_key: %i[blueprint_id activity material_id] do |t|
      t.references :blueprint, null: false
      t.references :material, null: false

      t.enum :activity, enum_type: :blueprint_activity, null: false
      t.integer :quantity, null: false

      t.index %i[blueprint_id activity material_id], unique: true, name: :index_unique_blueprint_activity_materials
    end

    create_table :blueprint_activity_skills, id: false, primary_key: %i[blueprint_id activity skill_id] do |t|
      t.references :blueprint, null: false
      t.references :skill, null: false

      t.enum :activity, enum_type: :blueprint_activity, null: false
      t.integer :level, null: false

      t.index %i[blueprint_id activity skill_id], unique: true, name: :index_unique_blueprint_activity_skills
    end

    create_table :blueprint_activity_products, id: false, primary_key: %i[blueprint_id activity product_id] do |t|
      t.references :blueprint, null: false
      t.references :product, null: false

      t.enum :activity, enum_type: :blueprint_activity, null: false
      t.integer :quantity, null: false
      t.decimal :probability

      t.index %i[blueprint_id activity product_id], unique: true, name: :index_unique_blueprint_activity_products
    end
  end
end
