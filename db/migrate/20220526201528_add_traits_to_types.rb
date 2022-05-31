# frozen_string_literal: true

class AddTraitsToTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :types, :traits, :jsonb, index: { using: :gin }
  end
end
