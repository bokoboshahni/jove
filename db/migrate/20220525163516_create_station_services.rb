# frozen_string_literal: true

class CreateStationServices < ActiveRecord::Migration[7.0]
  def change
    create_table :station_services do |t|
      t.text :description
      t.text :name, null: false
      t.timestamps null: false
    end

    create_table :station_operation_services, id: false, primary_key: %i[operation_id service_id] do |t|
      t.references :operation, null: false
      t.references :service, null: false

      t.index %i[operation_id service_id], unique: true, name: :index_unique_station_operation_services
    end
  end
end
