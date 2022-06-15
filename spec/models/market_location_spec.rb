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
require 'rails_helper'

RSpec.describe MarketLocation, type: :model do
end