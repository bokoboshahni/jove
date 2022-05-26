# frozen_string_literal: true

class CreateDogmaEffects < ActiveRecord::Migration[7.0]
  def change
    create_table :dogma_effects do |t|
      t.references :category, null: false
      t.references :discharge_attribute
      t.references :duration_attribute
      t.references :falloff_attribute
      t.references :fitting_usage_chance_attribute
      t.references :icon
      t.references :npc_activation_chance_attribute
      t.references :npc_usage_chance_attribute
      t.references :range_attribute
      t.references :resistance_attribute
      t.references :tracking_speed_attribute

      t.text :description
      t.boolean :disallow_auto_repeat, null: false
      t.text :display_name
      t.integer :distribution
      t.boolean :electronic_chance, null: false
      t.text :guid
      t.boolean :is_assistance, null: false
      t.boolean :is_offensive, null: false
      t.boolean :is_warp_safe, null: false
      t.text :name, null: false
      t.boolean :propulsion_chance, null: false
      t.boolean :published, null: false
      t.boolean :range_chance, null: false
      t.text :sfx_name
      t.timestamps null: false
    end

    create_table :dogma_effect_modifiers, id: :uuid do |t|
      t.references :effect, null: false
      t.references :group
      t.references :modified_attribute
      t.references :modified_effect
      t.references :modifying_attribute
      t.references :operation
      t.references :skill

      t.text :domain, null: false
      t.text :function, null: false
    end
  end
end
