# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_operation_services`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`operation_id`**  | `bigint`           | `not null`
# **`service_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_station_operation_services_on_operation_id`:
#     * **`operation_id`**
# * `index_station_operation_services_on_service_id`:
#     * **`service_id`**
# * `index_unique_station_operation_services` (_unique_):
#     * **`operation_id`**
#     * **`service_id`**
#
class StationOperationService < ApplicationRecord
  self.primary_keys = :operation_id, :service_id

  belongs_to :operation, class_name: 'StationOperation'
  belongs_to :service, class_name: 'StationService'
end
