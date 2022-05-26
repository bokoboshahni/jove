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

  belongs_to :category, class_name: 'DogmaCategory', optional: true
  belongs_to :charge_recharge_time_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :icon, optional: true
  belongs_to :max_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :unit, optional: true

  has_many :attributes_as_charge_recharge_time, class_name: 'DogmaAttribute',
                                                foreign_key: :charge_recharge_time_attribute_id
  has_many :attributes_as_max, class_name: 'DogmaAttribute', foreign_key: :max_attribute_id

  has_many :effects_as_discharge, class_name: 'DogmaEffect', foreign_key: :discharge_attribute_id
  has_many :effects_as_duration, class_name: 'DogmaEffect', foreign_key: :duration_attribute_id
  has_many :effects_as_falloff, class_name: 'DogmaEffect', foreign_key: :falloff_attribute_id
  has_many :effects_as_fitting_usage_chance, class_name: 'DogmaEffect', foreign_key: :fitting_usage_chance_attribute_id
  has_many :effects_as_npc_activation_chance, class_name: 'DogmaEffect',
                                              foreign_key: :npc_activation_chance_attribute_id
  has_many :effects_as_range, class_name: 'DogmaEffect', foreign_key: :range_attribute_id
  has_many :effects_as_resistance, class_name: 'DogmaEffect', foreign_key: :resistance_attribute_id
  has_many :effects_as_tracking_speed, class_name: 'DogmaEffect', foreign_key: :tracking_speed_attribute_id

  has_many :modifiers_as_modified_attribute, class_name: 'DogmaEffectModifier', foreign_key: :modified_attribute_id
  has_many :modifiers_as_modifying_attribute, class_name: 'DogmaEffectModifier', foreign_key: :modifying_attribute_id

  has_many :type_dogma_attributes
  has_many :types, through: :type_dogma_attributes

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
