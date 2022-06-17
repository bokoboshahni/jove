# frozen_string_literal: true

class RemoveRedundantIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :blueprint_activities, column: :blueprint_id
    remove_index :blueprint_activity_materials, column: :blueprint_id
    remove_index :blueprint_activity_products, column: :blueprint_id
    remove_index :blueprint_activity_skills, column: :blueprint_id
    remove_index :station_operation_services, column: :operation_id
  end
end
