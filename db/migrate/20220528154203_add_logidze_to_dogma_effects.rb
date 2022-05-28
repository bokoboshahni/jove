# frozen_string_literal: true

class AddLogidzeToDogmaEffects < ActiveRecord::Migration[7.0]
  def change
    add_column :dogma_effects, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_dogma_effects"
          BEFORE UPDATE OR INSERT ON "dogma_effects" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_dogma_effects" on "dogma_effects";
        SQL
      end
    end
  end
end
