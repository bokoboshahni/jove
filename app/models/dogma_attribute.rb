# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_attributes`
#
# ### Columns
#
# Name                              | Type               | Attributes
# --------------------------------- | ------------------ | ---------------------------
# **`id`**                          | `bigint`           | `not null, primary key`
# **`default_value`**               | `decimal(, )`      | `not null`
# **`description`**                 | `text`             |
# **`display_name`**                | `text`             |
# **`display_when_zero`**           | `boolean`          |
# **`high_is_good`**                | `boolean`          | `not null`
# **`name`**                        | `text`             | `not null`
# **`published`**                   | `boolean`          | `not null`
# **`stackable`**                   | `boolean`          | `not null`
# **`tooltip_description`**         | `text`             |
# **`tooltip_title`**               | `text`             |
# **`created_at`**                  | `datetime`         | `not null`
# **`updated_at`**                  | `datetime`         | `not null`
# **`category_id`**                 | `bigint`           |
# **`data_type_id`**                | `bigint`           |
# **`icon_id`**                     | `bigint`           |
# **`max_attribute_id`**            | `bigint`           |
# **`recharge_time_attribute_id`**  | `bigint`           |
# **`unit_id`**                     | `bigint`           |
#
# ### Indexes
#
# * `index_dogma_attributes_on_category_id`:
#     * **`category_id`**
# * `index_dogma_attributes_on_data_type_id`:
#     * **`data_type_id`**
# * `index_dogma_attributes_on_icon_id`:
#     * **`icon_id`**
# * `index_dogma_attributes_on_max_attribute_id`:
#     * **`max_attribute_id`**
# * `index_dogma_attributes_on_recharge_time_attribute_id`:
#     * **`recharge_time_attribute_id`**
# * `index_dogma_attributes_on_unit_id`:
#     * **`unit_id`**
#
class DogmaAttribute < ApplicationRecord
  include SDEImportable

  self.sde_exclude = %i[attribute_id]

  self.sde_rename = {
    charge_recharge_time_id: :recharge_time_attribute_id,
    data_type: :data_type_id
  }

  self.sde_localized = %i[display_name tooltip_description tooltip_title]

  belongs_to :category, optional: true
  belongs_to :charge_recharge_time_attribute, optional: true
  belongs_to :icon, optional: true
  belongs_to :max_attribute, optional: true
  belongs_to :unit, optional: true

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/dogmaAttributes.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
