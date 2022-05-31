# frozen_string_literal: true

class CreateIcons < ActiveRecord::Migration[7.0]
  def change
    create_table :icons do |t|
      t.text :description
      t.text :file, null: false
      t.boolean :obsolete
      t.timestamps null: false
    end
  end
end
