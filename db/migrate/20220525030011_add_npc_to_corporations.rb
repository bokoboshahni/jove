# frozen_string_literal: true

class AddNPCToCorporations < ActiveRecord::Migration[7.0]
  def up
    add_reference :corporations, :enemy
    add_reference :corporations, :friend
    add_reference :corporations, :icon
    add_reference :corporations, :main_activity
    add_reference :corporations, :race
    add_reference :corporations, :secondary_activity
    add_reference :corporations, :solar_system

    add_column :corporations, :deleted, :boolean, index: true
    add_column :corporations, :extent, :text
    add_column :corporations, :npc, :boolean
    add_column :corporations, :size_factor, :decimal
    add_column :corporations, :size, :text

    change_column :corporations, :ceo_id, :bigint, null: true
    change_column :corporations, :creator_id, :bigint, null: true
    change_column :corporations, :esi_etag, :text, null: true
    change_column :corporations, :esi_expires_at, :datetime, null: true
    change_column :corporations, :esi_last_modified_at, :datetime, null: true
    change_column :corporations, :member_count, :integer, null: true
    change_column :corporations, :share_count, :bigint
  end

  def down
    change_column :corporations, :share_count, :integer
    change_column :corporations, :member_count, :integer, null: false
    change_column :corporations, :esi_last_modified_at, :datetime, null: false
    change_column :corporations, :esi_expires_at, :datetime, null: false
    change_column :corporations, :esi_etag, :text, null: false
    change_column :corporations, :creator_id, :bigint, null: false
    change_column :corporations, :ceo_id, :bigint, null: false

    remove_column :corporations, :size
    remove_column :corporations, :size_factor
    remove_column :corporations, :npc, :boolean
    remove_column :corporations, :extent
    remove_column :corporations, :deleted, :boolean

    remove_reference :corporations, :solar_system
    remove_reference :corporations, :secondary_activity
    remove_reference :corporations, :race
    remove_reference :corporations, :main_activity
    remove_reference :corporations, :icon
    remove_reference :corporations, :friend
    remove_reference :corporations, :enemy
  end
end
