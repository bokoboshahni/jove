# frozen_string_literal: true

class AddWormholeClassToConstellations < ActiveRecord::Migration[7.0]
  def change
    add_reference :constellations, :wormhole_class
  end
end
