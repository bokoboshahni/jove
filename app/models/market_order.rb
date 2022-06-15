# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_orders`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`duration`**       | `integer`          | `not null`
# **`is_buy_order`**   | `boolean`          | `not null`
# **`issued`**         | `datetime`         | `not null`
# **`min_volume`**     | `integer`          | `not null`
# **`price`**          | `decimal(, )`      | `not null`
# **`range`**          | `enum`             | `not null`
# **`volume_remain`**  | `integer`          | `not null`
# **`volume_total`**   | `integer`          | `not null`
# **`created_at`**     | `datetime`         | `not null, primary key`
# **`location_id`**    | `bigint`           | `not null`
# **`order_id`**       | `bigint`           | `not null, primary key`
# **`source_id`**      | `integer`          | `not null, primary key`
# **`system_id`**      | `bigint`           | `not null`
# **`type_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_orders_on_order_type_and_type`:
#     * **`source_id`**
#     * **`location_id`**
#     * **`is_buy_order`**
#     * **`type_id`**
#     * **`created_at`**
# * `index_unique_market_orders` (_unique_):
#     * **`source_id`**
#     * **`order_id`**
#     * **`created_at`**
# * `market_orders_created_at_idx`:
#     * **`created_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`source_id => market_order_sources.id`**
#
class MarketOrder < ApplicationRecord
  self.primary_keys = :source_id, :order_id, :created_at

  acts_as_hypertable time_column: :created_at

  belongs_to :snapshot, class_name: 'MarketOrderSnapshot', foreign_key: %i[source_id created_at]
  belongs_to :system, class_name: 'SolarSystem'
  belongs_to :type

  scope :latest, -> { where(snapshot_id: MarketOrderSnapshot.latest.pluck(:id)).distinct(:order_id) }

  scope :latest_by_item, ->(type_id) { latest.where(type_id:) }

  scope :latest_by_item_and_type, ->(type_id, order_type) { latest.where(type_id:, order_type:) }

  scope :latest_buy_by_item, ->(type_id) { latest_by_item_and_type(type_id, :buy) }

  scope :latest_sell_by_item, ->(type_id) { latest_by_item_and_type(type_id, :sell) }

  enum :range, %i[station region solarsystem 1 2 3 4 5 10 20 30 40].index_with(&:to_s), _prefix: :range

  def as_esi_json
    attributes.except(:created_at, :source_id).symbolize_keys
  end
end
