# frozen_string_literal: true

class AddLogidzeToBloodlines < ActiveRecord::Migration[7.0]
  def change
    add_column :bloodlines, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_bloodlines"
          BEFORE UPDATE OR INSERT ON "bloodlines" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_bloodlines" on "bloodlines";
        SQL
      end
    end
  end
end
