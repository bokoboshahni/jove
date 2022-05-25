# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_operation_station_types`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`operation_id`**  | `bigint`           | `not null`
# **`race_id`**       | `bigint`           | `not null`
# **`type_id`**       | `bigint`           | `not null`
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
FactoryBot.define do
  factory :station_operation_station_type do
  end
end
