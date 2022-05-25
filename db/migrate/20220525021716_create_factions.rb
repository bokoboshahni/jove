# frozen_string_literal: true

class CreateFactions < ActiveRecord::Migration[7.0]
  def change
    create_table :factions do |t|
      t.references :corporation
      t.references :icon, null: false
      t.references :militia_corporation
      t.references :solar_system, null: false

      t.text :description, null: false
      t.text :name, null: false
      t.text :short_description
      t.decimal :size_factor, null: false
      t.timestamps null: false
    end

    create_table :faction_races, id: false, primary_key: %i[faction_id race_id] do |t|
      t.references :faction, null: false
      t.references :race, null: false

      t.index %i[faction_id race_id], unique: true, name: :index_unique_faction_races
    end
  end
end
