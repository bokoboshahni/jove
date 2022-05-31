# frozen_string_literal: true

class CreateBloodlines < ActiveRecord::Migration[7.0]
  def change
    create_table :bloodlines do |t|
      t.references :corporation, null: false
      t.references :icon
      t.references :race, null: false

      t.integer :charisma, null: false
      t.text :description, null: false
      t.integer :intelligence, null: false
      t.integer :memory, null: false
      t.text :name, null: false
      t.integer :perception, null: false
      t.integer :willpower, null: false
      t.timestamps null: false
    end
  end
end
