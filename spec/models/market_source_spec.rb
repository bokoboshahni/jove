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
require 'rails_helper'

RSpec.describe MarketSource, type: :model do
end
