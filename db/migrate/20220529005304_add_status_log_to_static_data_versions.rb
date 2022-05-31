# frozen_string_literal: true

class AddStatusLogToStaticDataVersions < ActiveRecord::Migration[7.0]
  def change
    add_column :static_data_versions, :status_log, :text, array: true
  end
end
