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
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
class StationService < ApplicationRecord
  include SDEImportable

  self.sde_rename = { service_name_id: :name_id }

  self.sde_localized = %i[description name]

  has_many :station_operation_services, foreign_key: :service_id

  has_many :operations, class_name: 'StationOperation', through: :station_operation_services

  has_many :stations, through: :operations

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/stationServices.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
