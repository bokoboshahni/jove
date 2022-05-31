# frozen_string_literal: true

class CreateStaticDataVersions < ActiveRecord::Migration[7.0]
  def change
    create_enum :static_data_version_status, %w[
      pending
      downloading
      downloaded
      downloading_failed
      importing
      imported
      importing_failed
    ]

    create_table :static_data_versions do |t|
      t.text :checksum, null: false, index: { unique: true }
      t.boolean :current, index: { unique: true }
      t.datetime :downloaded_at
      t.datetime :downloading_at
      t.datetime :downloading_failed_at
      t.datetime :imported_at
      t.datetime :importing_at
      t.datetime :importing_failed_at
      t.enum :status, enum_type: :static_data_version_status, null: false
      t.jsonb :status_exception
      t.timestamps null: false
    end
  end
end
