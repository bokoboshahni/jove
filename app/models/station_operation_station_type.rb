# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_operation_station_types`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`log_data`**      | `jsonb`            |
# **`operation_id`**  | `bigint`           | `not null, primary key`
# **`race_id`**       | `bigint`           | `not null, primary key`
# **`type_id`**       | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_station_operation_station_types_on_operation_id`:
#     * **`operation_id`**
# * `index_station_operation_station_types_on_race_id`:
#     * **`race_id`**
# * `index_station_operation_station_types_on_type_id`:
#     * **`type_id`**
# * `index_unique_station_operation_station_types` (_unique_):
#     * **`operation_id`**
#     * **`race_id`**
#     * **`type_id`**
#
class StationOperationStationType < ApplicationRecord
  include SDEImportable

  self.primary_keys = :operation_id, :race_id, :type_id

  self.inheritance_column = nil

  belongs_to :operation, class_name: 'StationOperation'
  belongs_to :race
  belongs_to :type
end
