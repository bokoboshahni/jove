# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_operations`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`border`**                | `boolean`          | `not null`
# **`corridor`**              | `boolean`          | `not null`
# **`description`**           | `text`             |
# **`fringe`**                | `boolean`          | `not null`
# **`hub`**                   | `boolean`          | `not null`
# **`log_data`**              | `jsonb`            |
# **`manufacturing_factor`**  | `decimal(, )`      | `not null`
# **`name`**                  | `text`             | `not null`
# **`ratio`**                 | `decimal(, )`      | `not null`
# **`research_factor`**       | `decimal(, )`      | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`activity_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_station_operations_on_activity_id`:
#     * **`activity_id`**
#
require 'rails_helper'

RSpec.describe StationOperation, type: :model do
end
