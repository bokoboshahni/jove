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

  self.sde_exclude = %i[skills]

  self.sde_localized_description = true
  self.sde_localized_name = true

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/races.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
