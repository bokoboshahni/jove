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
require 'rails_helper'

RSpec.describe DogmaEffectModifier, type: :model do
  describe '.import_all_from_sde' do
    let(:dogma_effect_modifiers) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/dogmaEffects.yaml')).values.map do |e|
        e['modifierInfo']
      end.flatten.compact
    end

    it 'saves each dogma effect modifier' do
      expect(described_class.import_all_from_sde.rows.count).to eq(dogma_effect_modifiers.count)
    end
  end
end
