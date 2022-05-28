# frozen_string_literal: true

class AddLogidzeToSolarSystems < ActiveRecord::Migration[7.0]
  def change
    add_column :solar_systems, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_solar_systems"
          BEFORE UPDATE OR INSERT ON "solar_systems" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_solar_systems" on "solar_systems";
        SQL
      end
    end
  end
end
