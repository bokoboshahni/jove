# frozen_string_literal: true

class CreateMetaGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :meta_groups do |t|
      t.references :icon

      t.text :description
      t.text :icon_suffix
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
