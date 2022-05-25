# frozen_string_literal: true

class CreateGraphics < ActiveRecord::Migration[7.0]
  def change
    create_table :graphics do |t|
      t.text :description
      t.text :graphic_file
      t.text :icon_folder
      t.text :skin_faction_name
      t.text :skin_hull_name
      t.text :skin_race_name
      t.timestamps null: false
    end
  end
end
