# frozen_string_literal: true

# ## Schema Information
#
# Table name: `bloodlines`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`charisma`**        | `integer`          | `not null`
# **`description`**     | `text`             | `not null`
# **`intelligence`**    | `integer`          | `not null`
# **`memory`**          | `integer`          | `not null`
# **`name`**            | `text`             | `not null`
# **`perception`**      | `integer`          | `not null`
# **`willpower`**       | `integer`          | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`corporation_id`**  | `bigint`           | `not null`
# **`icon_id`**         | `bigint`           |
# **`race_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bloodlines_on_corporation_id`:
#     * **`corporation_id`**
# * `index_bloodlines_on_icon_id`:
#     * **`icon_id`**
# * `index_bloodlines_on_race_id`:
#     * **`race_id`**
#
class Bloodline < ApplicationRecord
  include SDEImportable

  self.sde_localized = %i[description name]

  belongs_to :icon, optional: true

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/bloodlines.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
