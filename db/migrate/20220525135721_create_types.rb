# frozen_string_literal: true

class CreateTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :types do |t|
      t.references :faction
      t.references :graphic
      t.references :group, null: false
      t.references :icon
      t.integer :market_id, limit: 2, null: false
      t.references :meta_group
      t.references :race
      t.references :skin_material_set
      t.references :sound
      t.references :variation_parent_type

      t.decimal :base_price
      t.decimal :capacity
      t.text :description
      t.decimal :mass
      t.text :name, null: false
      t.decimal :packaged_volume
      t.integer :portion_size, null: false
      t.boolean :published, null: false
      t.decimal :radius
      t.text :skin_faction_name
      t.decimal :volume
      t.timestamps null: false
    end
  end
end
