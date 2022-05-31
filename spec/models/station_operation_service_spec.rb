# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_operation_services`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`log_data`**      | `jsonb`            |
# **`operation_id`**  | `bigint`           | `not null, primary key`
# **`service_id`**    | `bigint`           | `not null, primary key`
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
require 'rails_helper'

RSpec.describe StationOperationService, type: :model do
end
