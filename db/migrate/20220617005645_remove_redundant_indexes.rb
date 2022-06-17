# frozen_string_literal: true

class RemoveRedundantIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :faction_races, column: :faction_id
    remove_index :identities, column: :user_id
    remove_index :login_permits, column: %i[permittable_type permittable_id], name: :index_login_permits_on_permittable
    remove_index :station_operation_station_types, column: %i[operation_id]
  end
end
