# frozen_string_literal: true

class AddRetentionPolicyToMarketOrders < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute "SELECT add_retention_policy('market_orders', INTERVAL '12 hours')"
        execute "SELECT add_retention_policy('market_order_snapshots', INTERVAL '12 hours')"
      end

      dir.down do
        execute "SELECT remove_retention_policy('market_order_snapshots')"
        execute "SELECT remove_retention_policy('market_orders')"
      end
    end
  end
end
