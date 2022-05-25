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
require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '.import_all_from_sde' do
    let(:group_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/groupIDs.yaml')).keys
    end

    it 'saves each group' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(group_ids)
    end
  end
end
