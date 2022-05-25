# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.references :category, null: false
      t.references :icon

      t.boolean :anchorable, null: false
      t.boolean :anchored, null: false
      t.boolean :fittable_non_singleton, null: false
      t.text :name, null: false
      t.boolean :published, null: false
      t.boolean :use_base_price, null: false
      t.timestamps null: false
    end
  end
end
