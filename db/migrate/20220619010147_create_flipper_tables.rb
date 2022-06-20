# frozen_string_literal: true

class CreateFlipperTables < ActiveRecord::Migration[7.0]
  def change
    create_table :flipper_features do |t|
      t.text :key, null: false
      t.timestamps null: false

      t.index :key, unique: true, name: :index_unique_flipper_features
    end

    create_table :flipper_gates do |t|
      t.text :feature_key, null: false
      t.text :key, null: false
      t.text :value
      t.timestamps null: false

      t.index %i[feature_key key value], unique: true, name: :index_unique_flipper_gates
    end
  end
end
