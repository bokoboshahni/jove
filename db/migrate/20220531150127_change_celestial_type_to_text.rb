# frozen_string_literal: true

class ChangeCelestialTypeToText < ActiveRecord::Migration[7.0]
  def change
    change_column :celestials, :celestial_type, :text
  end
end
