# frozen_string_literal: true

# ## Schema Information
#
# Table name: `races`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`description`**   | `text`             |
# **`log_data`**      | `jsonb`            |
# **`name`**          | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`icon_id`**       | `bigint`           |
# **`ship_type_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_races_on_icon_id`:
#     * **`icon_id`**
# * `index_races_on_ship_type_id`:
#     * **`ship_type_id`**
#
class Race < ApplicationRecord
  include SDEImportable

  belongs_to :icon, optional: true
  belongs_to :ship_type, class_name: 'Type', optional: true

  has_many :station_operation_station_types
end
