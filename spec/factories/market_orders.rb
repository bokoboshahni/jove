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
FactoryBot.define do
  factory :market_order do
    duration { Faker::Number.within(range: 0..90) }
    is_buy_order { Faker::Boolean.boolean }
    issued { Faker::Time.between(from: 90.days.ago, to: DateTime.now).change(usec: 0) }
    location_id { Faker::Number.within(range: 68_000_000..69_000_000) }
    min_volume { 1 }
    order_id { Faker::Number.within(range: 0..10_000_000_000) }
    price { Faker::Number.within(range: 1.0..1_000_000.0) }
    range { MarketOrder.ranges.keys.sample }
    system_id { Faker::Number.within(range: 30_000_000..31_000_000) }
    type_id { Faker::Number.within(range: 0..1_000_000) }
    volume_remain { Faker::Number.within(range: 0..volume_total) }
    volume_total { Faker::Number.within(range: 1..100_000_000) }
  end
end
