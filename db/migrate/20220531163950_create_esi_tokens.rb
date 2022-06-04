# frozen_string_literal: true

class CreateESITokens < ActiveRecord::Migration[7.0]
  def change
    create_enum :esi_token_status, %w[
      requested
      approved
      rejected
      authorized
      revoked
      expired
    ]

    create_table :esi_tokens do |t|
      t.references :identity, null: false, foreign_key: { to_table: :identities }
      t.references :requester, null: false, foreign_key: { to_table: :identities }

      t.text :access_token
      t.datetime :approved_at
      t.datetime :authorized_at
      t.text :refresh_error_code
      t.text :refresh_error_description
      t.integer :refresh_error_status
      t.text :refresh_token
      t.datetime :refreshed_at
      t.datetime :rejected_at
      t.datetime :revoked_at
      t.datetime :expired_at
      t.datetime :expires_at
      t.text :scopes, array: true, null: false
      t.enum :status, enum_type: :esi_token_status, null: false
      t.timestamps null: false
    end

    create_enum :esi_grant_status, %w[
      requested
      approved
      rejected
      revoked
    ]

    create_table :esi_grants do |t|
      t.references :grantable, polymorphic: true
      t.references :requester, null: false, foreign_key: { to_table: :identities }
      t.references :token, null: false, foreign_key: { to_table: :esi_tokens }

      t.datetime :approved_at
      t.text :note
      t.datetime :rejected_at
      t.datetime :revoked_at
      t.text :type, null: false
      t.enum :status, enum_type: :esi_grant_status, null: false
      t.datetime :used_at
      t.timestamps null: false
    end
  end
end
