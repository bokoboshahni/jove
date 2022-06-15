# frozen_string_literal: true

class CreateMarketOrderSnapshots < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        create_enum :market_order_snapshot_status, %w[
          pending
          fetching
          fetched
          failed
          skipped
        ]

        create_table(
          :market_order_snapshots,
          id: false,
          primary_key: %i[source_id esi_expires_at created_at],
          hypertable: {
            time_column: 'created_at',
            chunk_time_interval: '1 hour'
          }
        ) do |t|
          t.integer :source_id, limit: 2, null: false

          t.text :esi_etag
          t.timestamp :esi_expires_at
          t.timestamp :esi_last_modified_at
          t.timestamp :failed_at
          t.timestamp :fetched_at
          t.timestamp :fetching_at
          t.timestamp :skipped_at
          t.enum :status, enum_type: :market_order_snapshot_status, null: false
          t.jsonb :status_exception
          t.timestamp :created_at, null: false
          t.timestamp :updated_at, null: false

          t.index %i[source_id esi_expires_at created_at], unique: true, name: :index_unique_market_order_snapshots

          t.foreign_key :market_order_sources, column: :source_id
        end

        create_enum :market_order_range, %w[station region solarsystem 1 2 3 4 5 10 20 30 40]

        create_table(
          :market_orders,
          id: false,
          primary_key: %i[source_id order_id created_at],
          hypertable: {
            time_column: 'created_at',
            chunk_time_interval: '1 hour'
          }
        ) do |t|
          t.references :system, null: false, index: false
          t.integer :source_id, limit: 2, null: false
          t.references :type, null: false, index: false

          t.integer :duration, limit: 2, null: false
          t.boolean :is_buy_order, null: false
          t.datetime :issued, null: false
          t.bigint :location_id, null: false
          t.integer :min_volume, null: false
          t.bigint :order_id, null: false
          t.decimal :price, null: false
          t.enum :range, enum_type: :market_order_range, null: false
          t.timestamp :created_at, null: false
          t.integer :volume_remain, null: false
          t.integer :volume_total, null: false

          t.index %i[source_id order_id created_at], unique: true, name: :index_unique_market_orders
          t.index %i[source_id location_id is_buy_order type_id created_at],
                  name: :index_market_orders_on_order_type_and_type

          t.foreign_key :market_order_sources, column: :source_id
        end
      end

      dir.down do
        drop_table :market_orders
        execute 'DROP TYPE market_order_range'
        drop_table :market_order_snapshots
        execute 'DROP TYPE market_order_snapshot_status'
      end
    end
  end
end
