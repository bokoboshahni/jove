# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, null: false

      t.datetime :created_at, null: false
      t.text :event, null: false
      t.jsonb :object
      t.jsonb :object_changes
      t.text :whodunnit

      t.index %i[item_type event]
      t.index %i[whodunnit item_type event]
    end
  end
end
