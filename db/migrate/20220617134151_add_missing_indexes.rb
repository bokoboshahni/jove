# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :esi_tokens, %i[grant_type resource_type resource_id], name: :index_esi_tokens_with_resources
    add_index :esi_tokens, :access_token, unique: true, name: :index_unique_esi_token_access_tokens
  end
end
