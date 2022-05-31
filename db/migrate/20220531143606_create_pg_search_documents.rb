# frozen_string_literal: true

class CreatePgSearchDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :pg_search_documents do |t|
      t.text :content
      t.belongs_to :searchable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
