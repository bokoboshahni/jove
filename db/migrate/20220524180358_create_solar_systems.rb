# frozen_string_literal: true

class CreateSolarSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :solar_systems do |t|
      t.references :constellation, null: false
      t.references :faction
      t.references :wormhole_class

      t.boolean :border, null: false
      t.decimal :center_x, null: false
      t.decimal :center_y, null: false
      t.decimal :center_z, null: false
      t.boolean :corridor, null: false
      t.integer :disallowed_anchor_categories, array: true
      t.integer :disallowed_anchor_groups, array: true
      t.boolean :fringe, null: false
      t.boolean :hub, null: false
      t.boolean :international, null: false
      t.decimal :luminosity, null: false
      t.decimal :max_x, null: false
      t.decimal :max_y, null: false
      t.decimal :max_z, null: false
      t.decimal :min_x, null: false
      t.decimal :min_y, null: false
      t.decimal :min_z, null: false
      t.decimal :radius, null: false
      t.boolean :regional, null: false
      t.decimal :security, null: false
      t.text :security_class
      t.text :name, null: false
      t.text :visual_effect
      t.timestamps null: false
    end
  end
end
