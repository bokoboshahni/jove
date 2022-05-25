# frozen_string_literal: true

class CreateCelestialTables < ActiveRecord::Migration[7.0]
  def change
    create_enum :celestial_type, %w[asteroid_belt moon planet secondary_sun star]

    create_table :celestials do |t|
      t.references :effect_beacon_type
      t.references :height_map_1 # rubocop:disable Naming/VariableNumber
      t.references :height_map_2 # rubocop:disable Naming/VariableNumber
      t.references :shader_preset
      t.references :solar_system, null: false
      t.references :type, null: false

      t.decimal :age
      t.text :ancestry
      t.integer :celestial_index
      t.enum :celestial_type, enum_type: :celestial_type, null: false
      t.decimal :density
      t.decimal :eccentricity
      t.decimal :escape_velocity
      t.boolean :fragmented
      t.decimal :life
      t.boolean :locked
      t.decimal :luminosity
      t.decimal :mass_dust
      t.decimal :mass_gas
      t.decimal :orbit_period
      t.decimal :orbit_radius
      t.text :name, null: false
      t.boolean :population
      t.decimal :position_x, null: false
      t.decimal :position_y, null: false
      t.decimal :position_z, null: false
      t.decimal :pressure
      t.decimal :radius
      t.decimal :rotation_rate
      t.text :spectral_class
      t.decimal :surface_gravity
      t.decimal :temperature
      t.timestamps null: false
    end
  end
end
