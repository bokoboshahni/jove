# frozen_string_literal: true

class CreateConstellations < ActiveRecord::Migration[7.0]
  def change
    create_table :constellations do |t|
      t.references :region, null: false

      t.decimal :center_x, null: false
      t.decimal :center_y, null: false
      t.decimal :center_z, null: false
      t.decimal :max_x, null: false
      t.decimal :max_y, null: false
      t.decimal :max_z, null: false
      t.decimal :min_x, null: false
      t.decimal :min_y, null: false
      t.decimal :min_z, null: false
      t.decimal :radius, null: false
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
