# frozen_string_literal: true

class AddLogidzeToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_regions"
          BEFORE UPDATE OR INSERT ON "regions" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_regions" on "regions";
        SQL
      end
    end
  end
end
