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
  include SDEImportable

  self.sde_exclude = %i[services station_types]

  self.sde_rename = { operation_name_id: :name_id }

  self.sde_localized = %i[description name]

  has_many :stations, foreign_key: :operation_id

  has_many :station_types, class_name: 'StationOperationStationType', foreign_key: :operation_id

  def self.import_all_from_sde(progress: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    data = YAML.load_file(File.join(sde_path, 'fsd/stationOperations.yaml'))
    progress&.update(total: data.count)

    station_types = data.map do |operation_id, operation|
      operation['stationTypes']&.map { |race_id, type_id| { operation_id:, race_id:, type_id: } }
    end.flatten.compact
    StationOperationStationType.upsert_all(station_types)

    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
