# frozen_string_literal: true

class CreateStructures < ActiveRecord::Migration[7.0]
  def change
    create_table :structures do |t|
      t.references :corporation, null: false
      t.references :solar_system, null: false
      t.references :type

      t.datetime :discarded_at
      t.text :esi_etag, null: false
      t.timestamp :esi_expires_at, null: false
      t.timestamp :esi_last_modified_at, null: false
      t.jsonb :log_data
      t.text :name, null: false
      t.decimal :position_x, null: false
      t.decimal :position_y, null: false
      t.decimal :position_z, null: false
      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_structures"
          BEFORE UPDATE OR INSERT ON "structures" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_structures" on "structures";
        SQL
      end
    end
  end
end
