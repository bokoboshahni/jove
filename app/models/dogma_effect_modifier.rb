# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_effect_modifiers`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `uuid`             | `not null, primary key`
# **`domain`**                  | `text`             | `not null`
# **`function`**                | `text`             | `not null`
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
#
class DogmaEffectModifier < ApplicationRecord
  include SDEImportable

  self.sde_rename = {
    func: :function,
    effect_id: :modified_effect_id,
    operation: :operation_id,
    skill_type_id: :skill_id
  }

  belongs_to :effect, class_name: 'DogmaEffect'
  belongs_to :group, optional: true
  belongs_to :modified_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :modified_effect, class_name: 'DogmaEffect', optional: true
  belongs_to :modifying_attribute, class_name: 'DogmaAttribute', optional: true
  belongs_to :skill, class_name: 'Type', optional: true

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/dogmaEffects.yaml'))
    progress&.update(total: data.count)
    rows = data.each_with_object([]) do |(id, orig), a|
      orig['modifierInfo']&.each do |modifier|
        a << map_sde_attributes(modifier, id: SecureRandom.uuid).merge!(effect_id: id)
      end

      progress&.advance
    end
    upsert_all(rows)
  end
end
