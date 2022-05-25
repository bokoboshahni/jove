# frozen_string_literal: true

# ## Schema Information
#
# Table name: `graphics`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`description`**        | `text`             |
# **`graphic_file`**       | `text`             |
# **`icon_folder`**        | `text`             |
# **`skin_faction_name`**  | `text`             |
# **`skin_hull_name`**     | `text`             |
# **`skin_race_name`**     | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
#
class Graphic < ApplicationRecord
  include SDEImportable

  self.sde_mapper = lambda { |data, **_kwargs|
    data[:icon_folder] = data.delete(:icon_info).fetch(:folder) if data[:icon_info]
  }

  self.sde_rename = {
    sof_faction_name: :skin_faction_name,
    sof_hull_name: :skin_hull_name,
    sof_race_name: :skin_race_name
  }

  has_many :types

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/graphicIDs.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
