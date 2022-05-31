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
# **`log_data`**                    | `jsonb`            |
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

  has_many :type_dogma_attributes
  has_many :types, through: :type_dogma_attributes
end
