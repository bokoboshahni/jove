# frozen_string_literal: true

# ## Schema Information
#
# Table name: `groups`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`anchorable`**              | `boolean`          | `not null`
# **`anchored`**                | `boolean`          | `not null`
# **`fittable_non_singleton`**  | `boolean`          | `not null`
# **`name`**                    | `text`             | `not null`
# **`published`**               | `boolean`          | `not null`
# **`use_base_price`**          | `boolean`          | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`category_id`**             | `bigint`           | `not null`
# **`icon_id`**                 | `bigint`           |
#
# ### Indexes
#
# * `index_groups_on_category_id`:
#     * **`category_id`**
# * `index_groups_on_icon_id`:
#     * **`icon_id`**
#
class Group < ApplicationRecord
  include SDEImportable

  self.sde_localized = %i[name]

  belongs_to :category
  belongs_to :icon, optional: true

  has_many :dogma_effect_modifiers

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/groupIDs.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
