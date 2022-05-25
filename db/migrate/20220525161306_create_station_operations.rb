# frozen_string_literal: true

class CreateStationOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :station_operations do |t|
      t.references :activity, null: false

      t.boolean :border, null: false
      t.boolean :corridor, null: false
      t.text :description
      t.boolean :fringe, null: false
      t.boolean :hub, null: false
      t.decimal :manufacturing_factor, null: false
      t.text :name, null: false
      t.decimal :ratio, null: false
      t.decimal :research_factor, null: false
      t.timestamps null: false
    end

    create_table :station_operation_station_types, id: false, primary_key: %i[operation_id race_id type_id] do |t|
      t.references :operation, null: false
      t.references :race, null: false
      t.references :type, null: false

      t.index %i[operation_id race_id type_id], unique: true, name: :index_unique_station_operation_station_types
    end
  end
end
