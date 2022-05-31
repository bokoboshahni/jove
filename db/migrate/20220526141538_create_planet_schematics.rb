# frozen_string_literal: true

class CreatePlanetSchematics < ActiveRecord::Migration[7.0]
  def change
    create_table :planet_schematics do |t|
      t.references :output, null: false

      t.interval :time, null: false
      t.text :name, null: false
      t.integer :output_quantity, null: false
      t.integer :pins, array: true, null: false
      t.timestamps null: false
    end

    create_table :planet_schematic_inputs, id: false, primary_key: %i[schematic_id type_id] do |t|
      t.references :schematic, null: false, index: false
      t.references :type, null: false, index: false

      t.integer :quantity, null: false

      t.index %i[schematic_id type_id], unique: true, name: :index_unique_planet_schematic_inputs
    end

    create_table :planet_schematic_pins, id: false, primary_key: %i[schematic_id type_id] do |t|
      t.references :schematic, null: false, index: false
      t.references :type, null: false, index: false

      t.index %i[schematic_id type_id], unique: true, name: :index_unique_planet_schematic_pins
    end
  end
end
