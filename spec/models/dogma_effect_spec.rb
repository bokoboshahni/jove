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
require 'rails_helper'

RSpec.describe DogmaEffect, type: :model do
  describe '.import_all_from_sde' do
    let(:dogma_effect_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/dogmaEffects.yaml')).keys
    end

    it 'saves each dogma effect' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(dogma_effect_ids)
    end
  end
end
