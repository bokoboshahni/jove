# frozen_string_literal: true

class CreateDogmaAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :dogma_attributes do |t|
      t.references :category
      t.references :recharge_time_attribute
      t.references :data_type
      t.references :icon
      t.references :max_attribute
      t.references :unit

      t.decimal :default_value, null: false
      t.text :description
      t.text :display_name
      t.boolean :display_when_zero
      t.boolean :high_is_good, null: false
      t.text :name, null: false
      t.boolean :published, null: false
      t.boolean :stackable, null: false
      t.text :tooltip_description
      t.text :tooltip_title
      t.timestamps null: false
    end
  end
end
