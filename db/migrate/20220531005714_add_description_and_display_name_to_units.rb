# frozen_string_literal: true

class AddDescriptionAndDisplayNameToUnits < ActiveRecord::Migration[7.0]
  def change
    add_column :units, :description, :text
    add_column :units, :display_name, :text
  end
end
