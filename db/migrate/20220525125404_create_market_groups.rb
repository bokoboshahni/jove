# frozen_string_literal: true

class CreateMarketGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :market_groups do |t|
      t.references :icon

      t.text :ancestry, index: true
      t.integer :ancestry_depth, null: false, default: 0
      t.text :description
      t.boolean :has_types, null: false
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
