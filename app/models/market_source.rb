# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_sources`
#
# ### Columns
#
# Name             | Type               | Attributes
# ---------------- | ------------------ | ---------------------------
# **`market_id`**  | `integer`          | `not null, primary key`
# **`source_id`**  | `integer`          | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_sources` (_unique_):
#     * **`market_id`**
#     * **`source_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
# * `fk_rails_...`:
#     * **`source_id => market_order_sources.id`**
#
class MarketSource < ApplicationRecord
  self.primary_keys = :market_id, :source_id

  belongs_to :market
  belongs_to :source, class_name: 'MarketOrderSource'

  accepts_nested_attributes_for :source

  delegate :name, to: :source, allow_nil: true
end
