# frozen_string_literal: true

class ChangePkeyOnDogmaEffectModifiers < ActiveRecord::Migration[7.0]
  def change
    add_column :dogma_effect_modifiers, :position, :integer, null: false
    add_index :dogma_effect_modifiers, %i[effect_id position], unique: true, name: :index_unique_dogma_effect_modifiers

    reversible do |dir|
      dir.up do
        execute <<~SQL
          ALTER TABLE ONLY public.dogma_effect_modifiers
            DROP CONSTRAINT dogma_effect_modifiers_pkey;
        SQL
      end

      dir.down do
        execute <<~SQL
          ALTER TABLE ONLY public.dogma_effect_modifiers
            ADD CONSTRAINT dogma_effect_modifiers_pkey PRIMARY KEY (id);
        SQL
      end
    end

    remove_column :dogma_effect_modifiers, :id, :uuid
  end
end
