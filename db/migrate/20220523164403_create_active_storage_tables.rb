# frozen_string_literal: true

class CreateActiveStorageTables < ActiveRecord::Migration[5.2]
  def change
    create_table :active_storage_blobs, id: :uuid do |t|
      t.bigint :byte_size, null: false
      t.text :checksum
      t.text :content_type
      t.datetime :created_at, precision: 6, null: false
      t.text :filename, null: false
      t.text :key, null: false, index: { unique: true, name: :index_unique_active_storage_blobs }
      t.text :metadata
      t.text :service_name, null: false
    end

    create_table :active_storage_attachments, id: :uuid do |t|
      t.references :record, null: false, polymorphic: true, index: false
      t.references :blob, null: false, type: :uuid, foreign_key: { to_table: :active_storage_blobs }

      t.datetime :created_at, precision: 6, null: false
      t.text :name, null: false

      t.index %i[record_type record_id name blob_id], name: :index_unique_active_storage_attachments,
                                                      unique: true
    end

    create_table :active_storage_variant_records, id: :uuid do |t|
      t.belongs_to :blob, null: false, index: false, type: :uuid, foreign_key: { to_table: :active_storage_blobs }
      t.text :variation_digest, null: false

      t.index %i[blob_id variation_digest], name: :index_unique_active_storage_variant_records, unique: true
    end
  end
end
