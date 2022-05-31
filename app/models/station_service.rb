# frozen_string_literal: true

# ## Schema Information
#
# Table name: `station_services`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`log_data`**     | `jsonb`            |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
class StationService < ApplicationRecord
  include SDEImportable

  has_many :station_operation_services, foreign_key: :service_id

  has_many :operations, class_name: 'StationOperation', through: :station_operation_services

  has_many :stations, through: :operations
end
