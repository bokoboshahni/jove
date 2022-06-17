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
class MarketLocation < ApplicationRecord
  self.primary_keys = :market_id, :location_type, :location_id

  belongs_to :market
  belongs_to :location, polymorphic: true

  delegate :name, to: :location

  validates :location_type, inclusion: { in: %w[Region Station Structure] }
  validates :location_id, uniqueness: { scope: %i[location_type market_id] }
end
