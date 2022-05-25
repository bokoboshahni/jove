# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id`**                        | `bigint`           | `not null, primary key`
# **`base_price`**                | `decimal(, )`      |
# **`capacity`**                  | `decimal(, )`      |
# **`description`**               | `text`             |
# **`mass`**                      | `decimal(, )`      |
# **`name`**                      | `text`             | `not null`
# **`packaged_volume`**           | `decimal(, )`      |
# **`portion_size`**              | `integer`          | `not null`
# **`published`**                 | `boolean`          | `not null`
# **`radius`**                    | `decimal(, )`      |
# **`skin_faction_name`**         | `text`             |
# **`volume`**                    | `decimal(, )`      |
# **`created_at`**                | `datetime`         | `not null`
# **`updated_at`**                | `datetime`         | `not null`
# **`faction_id`**                | `bigint`           |
# **`graphic_id`**                | `bigint`           |
# **`group_id`**                  | `bigint`           | `not null`
# **`icon_id`**                   | `bigint`           |
# **`market_group_id`**           | `bigint`           |
# **`meta_group_id`**             | `bigint`           |
# **`race_id`**                   | `bigint`           |
# **`skin_material_set_id`**      | `bigint`           |
# **`sound_id`**                  | `bigint`           |
# **`variation_parent_type_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_types_on_faction_id`:
#     * **`faction_id`**
# * `index_types_on_graphic_id`:
#     * **`graphic_id`**
# * `index_types_on_group_id`:
#     * **`group_id`**
# * `index_types_on_icon_id`:
#     * **`icon_id`**
# * `index_types_on_market_group_id`:
#     * **`market_group_id`**
# * `index_types_on_meta_group_id`:
#     * **`meta_group_id`**
# * `index_types_on_race_id`:
#     * **`race_id`**
# * `index_types_on_skin_material_set_id`:
#     * **`skin_material_set_id`**
# * `index_types_on_sound_id`:
#     * **`sound_id`**
# * `index_types_on_variation_parent_type_id`:
#     * **`variation_parent_type_id`**
#
require 'rails_helper'

RSpec.describe Type, type: :model do
  describe '.import_all_from_sde' do
    let(:type_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/typeIDs.yaml')).keys
    end

    it 'saves each type' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(type_ids)
    end
  end
end
