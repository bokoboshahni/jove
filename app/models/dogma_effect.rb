# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_effects`
#
# ### Columns
#
# Name                                      | Type               | Attributes
# ----------------------------------------- | ------------------ | ---------------------------
# **`id`**                                  | `bigint`           | `not null, primary key`
# **`description`**                         | `text`             |
# **`disallow_auto_repeat`**                | `boolean`          | `not null`
# **`display_name`**                        | `text`             |
# **`distribution`**                        | `integer`          |
# **`electronic_chance`**                   | `boolean`          | `not null`
# **`guid`**                                | `text`             |
# **`is_assistance`**                       | `boolean`          | `not null`
# **`is_offensive`**                        | `boolean`          | `not null`
# **`is_warp_safe`**                        | `boolean`          | `not null`
# **`name`**                                | `text`             | `not null`
# **`propulsion_chance`**                   | `boolean`          | `not null`
# **`published`**                           | `boolean`          | `not null`
# **`range_chance`**                        | `boolean`          | `not null`
# **`sfx_name`**                            | `text`             |
# **`created_at`**                          | `datetime`         | `not null`
# **`updated_at`**                          | `datetime`         | `not null`
# **`category_id`**                         | `bigint`           | `not null`
# **`discharge_attribute_id`**              | `bigint`           |
# **`duration_attribute_id`**               | `bigint`           |
# **`falloff_attribute_id`**                | `bigint`           |
# **`fitting_usage_chance_attribute_id`**   | `bigint`           |
# **`icon_id`**                             | `bigint`           |
# **`npc_activation_chance_attribute_id`**  | `bigint`           |
# **`npc_usage_chance_attribute_id`**       | `bigint`           |
# **`range_attribute_id`**                  | `bigint`           |
# **`resistance_attribute_id`**             | `bigint`           |
# **`tracking_speed_attribute_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_dogma_effects_on_category_id`:
#     * **`category_id`**
# * `index_dogma_effects_on_discharge_attribute_id`:
#     * **`discharge_attribute_id`**
# * `index_dogma_effects_on_duration_attribute_id`:
#     * **`duration_attribute_id`**
# * `index_dogma_effects_on_falloff_attribute_id`:
#     * **`falloff_attribute_id`**
# * `index_dogma_effects_on_fitting_usage_chance_attribute_id`:
#     * **`fitting_usage_chance_attribute_id`**
# * `index_dogma_effects_on_icon_id`:
#     * **`icon_id`**
# * `index_dogma_effects_on_npc_activation_chance_attribute_id`:
#     * **`npc_activation_chance_attribute_id`**
# * `index_dogma_effects_on_npc_usage_chance_attribute_id`:
#     * **`npc_usage_chance_attribute_id`**
# * `index_dogma_effects_on_range_attribute_id`:
#     * **`range_attribute_id`**
# * `index_dogma_effects_on_resistance_attribute_id`:
#     * **`resistance_attribute_id`**
# * `index_dogma_effects_on_tracking_speed_attribute_id`:
#     * **`tracking_speed_attribute_id`**
#
class DogmaEffect < ApplicationRecord
  belongs_to :category, class_name: 'DogmaCategory'
  belongs_to :discharge_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :duration_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :falloff_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :fitting_usage_chance_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :icon, optional: true
  belongs_to :npc_activation_chance_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :npc_usage_chance_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :range_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :resistance_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :tracking_speed_attribute, class_name: 'DogmaAttribute', optional: true

  has_many :modifiers, class_name: 'DogmaEffectModifier', foreign_key: :effect_id

  has_many :modifiers_as_modified_effect, class_name: 'DogmaEffectModifier', foreign_key: :modified_effect_id

  has_many :type_dogma_effects
  has_many :types, through: :type_dogma_effects
end
