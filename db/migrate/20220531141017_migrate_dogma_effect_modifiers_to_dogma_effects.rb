# frozen_string_literal: true

class MigrateDogmaEffectModifiersToDogmaEffects < ActiveRecord::Migration[7.0]
  def change
    add_column :dogma_effects, :modifiers, :jsonb, index: { using: :gin }

    drop_table :dogma_effect_modifiers
  end
end
