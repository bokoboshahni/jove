# frozen_string_literal: true

class CreateMarkets < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        create_enum :market_status, %w[
          pending
          aggregating
          aggregated
          aggregating_failed
          disabled
        ]

        create_table :markets do |t|
          t.timestamp :aggregating_at
          t.timestamp :aggregating_failed_at
          t.timestamp :aggregated_at
          t.timestamp :disabled_at
          t.timestamp :expires_at
          t.boolean :hub
          t.boolean :regional
          t.text :name, null: false
          t.text :description
          t.timestamp :pending_at
          t.text :slug, null: false, index: { unique: true, name: :index_unique_market_slugs }
          t.enum :status, enum_type: :market_status, null: false
          t.jsonb :status_exception
          t.timestamps null: false
        end

        change_column :markets, :id, :integer, limit: 2

        create_table :market_locations, id: false, primary_key: %i[market_id location_type location_id] do |t|
          t.references :location, polymorphic: true, null: false, index: false
          t.integer :market_id, limit: 2, null: false

          t.index %i[market_id location_type location_id], unique: true, name: :index_unique_market_locations
        end
      end

      dir.down do
        drop_table :market_locations
        drop_table :markets
        execute 'DROP TYPE market_status'
      end
    end
  end
end
