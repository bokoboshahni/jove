# frozen_string_literal: true

# ## Schema Information
#
# Table name: `meta_groups`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`icon_suffix`**  | `text`             |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`icon_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_meta_groups_on_icon_id`:
#     * **`icon_id`**
#
class MetaGroup < ApplicationRecord
  include SDEImportable

  self.sde_localized = %i[description name]

  has_many :types

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/metaGroups.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
