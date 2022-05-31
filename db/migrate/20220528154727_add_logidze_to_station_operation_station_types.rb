# frozen_string_literal: true

class AddLogidzeToStationOperationStationTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :station_operation_station_types, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_station_operation_station_types"
          BEFORE UPDATE OR INSERT ON "station_operation_station_types" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_station_operation_station_types" on "station_operation_station_types";
        SQL
      end
    end
  end
end