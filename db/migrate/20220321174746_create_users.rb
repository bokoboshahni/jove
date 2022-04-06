# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    create_table :alliances do |t|
      t.references :creator_corporation, null: false
      t.references :creator, null: false
      t.references :executor_corporation
      t.references :faction

      t.text :esi_etag, null: false
      t.timestamp :esi_expires_at, null: false
      t.timestamp :esi_last_modified_at, null: false
      t.date :founded_on, null: false
      t.text :name, null: false
      t.text :ticker, null: false
      t.timestamps null: false
    end

    create_table :corporations do |t|
      t.references :alliance
      t.references :ceo, null: false
      t.references :creator, null: false
      t.references :faction
      t.references :home_station

      t.text :description
      t.text :esi_etag, null: false
      t.timestamp :esi_expires_at, null: false
      t.timestamp :esi_last_modified_at, null: false
      t.date :founded_on
      t.integer :member_count, null: false
      t.text :name, null: false
      t.integer :share_count
      t.decimal :tax_rate, null: false
      t.text :ticker, null: false
      t.text :url
      t.boolean :war_eligible
      t.timestamps null: false
    end

    create_table :characters do |t|
      t.references :bloodline, null: false
      t.references :corporation, null: false
      t.references :faction
      t.references :race, null: false

      t.date :birthday, null: false
      t.text :description
      t.text :esi_etag, null: false
      t.timestamp :esi_expires_at, null: false
      t.timestamp :esi_last_modified_at, null: false
      t.text :gender, null: false
      t.text :name, null: false
      t.text :owner_hash
      t.decimal :security_status
      t.text :title
      t.timestamps null: false
    end

    create_table :users do |t|
      t.boolean :admin
      t.timestamps null: false
    end

    create_table :identities do |t|
      t.references :character, null: false, index: { unique: true }
      t.references :user, null: false

      t.boolean :default
      t.timestamps null: false

      t.index %i[user_id default], unique: true, name: :index_unique_default_identities
    end

    create_table :login_activities do |t|
      t.references :user, polymorphic: true

      t.text :context
      t.datetime :created_at, null: false
      t.text :failure_reason
      t.text :identity, index: true
      t.text :ip, index: true
      t.text :referrer
      t.text :scope
      t.text :strategy
      t.boolean :success
      t.text :user_agent
    end

    create_table :login_permits do |t|
      t.references :permittable, polymorphic: true

      t.datetime :created_at, null: false
      t.text :name, null: false

      t.index %i[permittable_type permittable_id], unique: true, name: :index_unique_login_permits
    end
  end
end
