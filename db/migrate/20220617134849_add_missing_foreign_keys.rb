# frozen_string_literal: true

class AddMissingForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :corporations, :alliances
    add_foreign_key :structures, :corporations
    add_foreign_key :structures, :solar_systems
    add_foreign_key :structures, :types
  end
end
