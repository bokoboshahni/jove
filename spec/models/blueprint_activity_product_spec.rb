# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activity_products`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`log_data`**      | `jsonb`            |
# **`probability`**   | `decimal(, )`      |
# **`quantity`**      | `integer`          | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
# **`product_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activity_products_on_product_id`:
#     * **`product_id`**
# * `index_unique_blueprint_activity_products` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#     * **`product_id`**
#
require 'rails_helper'

RSpec.describe BlueprintActivityProduct, type: :model do
end
