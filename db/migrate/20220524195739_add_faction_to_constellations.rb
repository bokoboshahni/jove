# frozen_string_literal: true

class AddFactionToConstellations < ActiveRecord::Migration[7.0]
  def change
    add_reference :constellations, :faction
  end
end
