# frozen_string_literal: true

class CreateRaces < ActiveRecord::Migration[7.0]
  def change
    create_table :races do |t|
      t.references :icon
      t.references :ship_type

      t.text :description
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
