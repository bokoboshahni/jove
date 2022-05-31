# frozen_string_literal: true

class CreateStargates < ActiveRecord::Migration[7.0]
  def change
    create_table :stargates do |t|
      t.references :destination, null: false
      t.references :solar_system, null: false
      t.references :type, null: false

      t.text :name, null: false
      t.decimal :position_x, null: false
      t.decimal :position_y, null: false
      t.decimal :position_z, null: false
      t.timestamps null: false
    end
  end
end
