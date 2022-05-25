# frozen_string_literal: true

# ## Schema Information
#
# Table name: `meta_groups`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`icon_suffix`**  | `text`             |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`icon_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_meta_groups_on_icon_id`:
#     * **`icon_id`**
#
require 'rails_helper'

RSpec.describe MetaGroup, type: :model do
  describe '.import_all_from_sde' do
    let(:meta_group_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/metaGroups.yaml')).keys
    end

    it 'saves each meta group' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(meta_group_ids)
    end
  end
end
