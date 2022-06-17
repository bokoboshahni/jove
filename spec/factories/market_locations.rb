# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_locations`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`location_type`**  | `string`           | `not null, primary key`
# **`location_id`**    | `bigint`           | `not null, primary key`
# **`market_id`**      | `integer`          | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_locations` (_unique_):
#     * **`market_id`**
#     * **`location_type`**
#     * **`location_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
#
FactoryBot.define do
  factory :market_location do
    association :location, factory: :region
  end
end
