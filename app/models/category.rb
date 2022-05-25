# frozen_string_literal: true

# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`published`**   | `boolean`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`icon_id`**     | `bigint`           |
#
# ### Indexes
#
# * `index_categories_on_icon_id`:
#     * **`icon_id`**
#
class Category < ApplicationRecord
  include SDEImportable

  self.sde_localized = %i[name]

  has_many :groups

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/categoryIDs.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
