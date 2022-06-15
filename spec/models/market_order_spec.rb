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
require 'rails_helper'

RSpec.describe MarketOrder, type: :model do
end
