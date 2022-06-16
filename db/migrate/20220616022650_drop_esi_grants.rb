# frozen_string_literal: true

class DropESIGrants < ActiveRecord::Migration[7.0]
  def change
    drop_table :esi_grants
  end
end
