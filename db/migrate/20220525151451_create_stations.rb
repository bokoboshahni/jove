# frozen_string_literal: true

class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.references :celestial, null: false
      t.references :corporation, null: false
      t.references :graphic, null: false
      t.references :operation, null: false
      t.references :reprocessing_hangar_flag, null: false
      t.references :type, null: false

      t.boolean :conquerable, null: false
      t.decimal :docking_cost_per_volume, null: false
      t.decimal :max_ship_volume_dockable, null: false
      t.text :name, null: false
      t.decimal :office_rental_cost, null: false
      t.decimal :position_x, null: false
      t.decimal :position_y, null: false
      t.decimal :position_z, null: false
      t.decimal :reprocessing_efficiency, null: false
      t.decimal :reprocessing_station_take, null: false
      t.boolean :use_operation_name, null: false
      t.timestamps null: false
    end
  end
end
