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
class StationOperation < ApplicationRecord
  has_many :stations, foreign_key: :operation_id
  has_many :station_operation_services, foreign_key: :operation_id
  has_many :station_types, class_name: 'StationOperationStationType', foreign_key: :operation_id

  has_many :services, class_name: 'StationService', through: :station_operation_services
end
