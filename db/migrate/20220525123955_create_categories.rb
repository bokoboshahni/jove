# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.references :icon

      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end
  end
end
