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
FactoryBot.define do
  factory :station_operation do
    border { false }
    corridor { false }
    fringe { false }
    hub { false }
    manufacturing_factor { 1.0 }
    name { Faker::Commerce.department }
    ratio { 1.0 }
    research_factor { 1.0 }
    activity_id { 1 }
  end
end
