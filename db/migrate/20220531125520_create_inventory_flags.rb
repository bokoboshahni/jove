# frozen_string_literal: true

class CreateInventoryFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_flags do |t|
      t.text :name, null: false
      t.integer :order, null: false
      t.text :text, null: false
      t.timestamps null: false
    end
  end
end
