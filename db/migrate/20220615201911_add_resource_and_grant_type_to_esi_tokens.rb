# frozen_string_literal: true

class AddResourceAndGrantTypeToESITokens < ActiveRecord::Migration[7.0]
  def change
    add_reference :esi_tokens, :resource, polymorphic: true, index: false

    add_column :esi_tokens, :grant_type, :text
    add_column :esi_tokens, :used_at, :timestamp
  end
end
