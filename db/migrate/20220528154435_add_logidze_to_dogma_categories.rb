# frozen_string_literal: true

class AddLogidzeToDogmaCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :dogma_categories, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER "logidze_on_dogma_categories"
          BEFORE UPDATE OR INSERT ON "dogma_categories" FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at');

        SQL
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_dogma_categories" on "dogma_categories";
        SQL
      end
    end
  end
end
