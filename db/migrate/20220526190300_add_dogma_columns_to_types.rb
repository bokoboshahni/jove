# frozen_string_literal: true

class AddDogmaColumnsToTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :types, :dogma_attributes, :jsonb, index: { using: :gin }
    add_column :types, :dogma_effects, :jsonb, index: { using: :gin }
  end
end
