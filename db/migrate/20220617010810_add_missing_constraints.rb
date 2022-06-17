# frozen_string_literal: true

class AddMissingConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column :login_permits, :permittable_id, :bigint, null: false
    change_column :login_permits, :permittable_type, :text, null: false

    add_foreign_key :identities, :characters
    add_foreign_key :identities, :users
    add_foreign_key :market_locations, :markets
  end
end
