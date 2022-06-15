# frozen_string_literal: true

class CreateMarketOrderSources < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        create_enum :market_order_source_status, %w[pending fetching fetched fetching_failed disabled]

        create_table :market_order_sources do |t|
          t.references :source, polymorphic: true, index: false, null: false

          t.timestamp :disabled_at
          t.timestamp :expires_at
          t.timestamp :fetching_at
          t.timestamp :fetched_at
          t.timestamp :fetching_failed_at
          t.text :name, null: false
          t.timestamp :pending_at
          t.enum :status, enum_type: :market_order_source_status, null: false
          t.jsonb :status_exception
          t.timestamps null: false

          t.index %i[source_type source_id], unique: true, name: :index_unique_market_order_sources
        end

        change_column :market_order_sources, :id, :integer, limit: 2

        create_table :market_sources, id: false, primary_key: %i[market_id source_id] do |t|
          t.integer :market_id, limit: 2, null: false
          t.integer :source_id, limit: 2, null: false

          t.index %i[market_id source_id], unique: true, name: :index_unique_market_sources

          t.foreign_key :markets
          t.foreign_key :market_order_sources, column: :source_id
        end
      end

      dir.down do
        drop_table :market_sources
        drop_table :market_order_sources
        execute 'DROP TYPE market_order_source_status'
      end
    end
  end
end
