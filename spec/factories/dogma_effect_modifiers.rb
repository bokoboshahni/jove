# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_effect_modifiers`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`domain`**                  | `text`             | `not null`
# **`function`**                | `text`             | `not null`
# **`log_data`**                | `jsonb`            |
# **`position`**                | `integer`          | `not null`
# **`effect_id`**               | `bigint`           | `not null`
# **`group_id`**                | `bigint`           |
# **`modified_attribute_id`**   | `bigint`           |
# **`modified_effect_id`**      | `bigint`           |
# **`modifying_attribute_id`**  | `bigint`           |
# **`operation_id`**            | `bigint`           |
# **`skill_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_dogma_effect_modifiers_on_effect_id`:
#     * **`effect_id`**
# * `index_dogma_effect_modifiers_on_group_id`:
#     * **`group_id`**
# * `index_dogma_effect_modifiers_on_modified_attribute_id`:
#     * **`modified_attribute_id`**
# * `index_dogma_effect_modifiers_on_modified_effect_id`:
#     * **`modified_effect_id`**
# * `index_dogma_effect_modifiers_on_modifying_attribute_id`:
#     * **`modifying_attribute_id`**
# * `index_dogma_effect_modifiers_on_operation_id`:
#     * **`operation_id`**
# * `index_dogma_effect_modifiers_on_skill_id`:
#     * **`skill_id`**
# * `index_unique_dogma_effect_modifiers` (_unique_):
#     * **`effect_id`**
#     * **`position`**
#
FactoryBot.define do
  factory :dogma_effect_modifier do
  end
end
