# frozen_string_literal: true

# ## Schema Information
#
# Table name: `inventory_flags`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`log_data`**    | `jsonb`            |
# **`name`**        | `text`             | `not null`
# **`order`**       | `integer`          | `not null`
# **`text`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe InventoryFlag, type: :model do
end
