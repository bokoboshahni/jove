# frozen_string_literal: true

class CreateTypeMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :type_materials, id: false, primary_key: %i[type_id material_id] do |t|
      t.references :type, null: false, index: false
      t.references :material, null: false, index: false

      t.integer :quantity, null: false
      t.timestamps null: false

      t.index %i[type_id material_id], unique: true, name: :index_unique_type_materials
    end
  end
end
