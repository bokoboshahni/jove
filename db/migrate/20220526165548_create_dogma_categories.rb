# frozen_string_literal: true

class CreateDogmaCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :dogma_categories do |t|
      t.text :description
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
