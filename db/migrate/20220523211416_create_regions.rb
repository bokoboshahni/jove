# frozen_string_literal: true

class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_enum :universe, %w[abyssal eve void wormhole]

    create_table :regions do |t|
      t.references :faction
      t.references :nebula
      t.references :wormhole_class

      t.decimal :center_x, null: false
      t.decimal :center_y, null: false
      t.decimal :center_z, null: false
      t.text :description
      t.decimal :max_x, null: false
      t.decimal :max_y, null: false
      t.decimal :max_z, null: false
      t.decimal :min_x, null: false
      t.decimal :min_y, null: false
      t.decimal :min_z, null: false
      t.text :name, null: false
      t.enum :universe, enum_type: :universe, null: false
      t.timestamps null: false
    end
  end
end
