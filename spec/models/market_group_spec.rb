# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_groups`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`ancestry_depth`**  | `integer`          | `default(0), not null`
# **`description`**     | `text`             |
# **`has_types`**       | `boolean`          | `not null`
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`icon_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_market_groups_on_ancestry`:
#     * **`ancestry`**
# * `index_market_groups_on_icon_id`:
#     * **`icon_id`**
#
require 'rails_helper'

RSpec.describe MarketGroup, type: :model do
  describe '.import_all_from_sde' do
    let(:market_group_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/marketGroups.yaml')).keys
    end

    it 'saves each market group' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(market_group_ids)
    end

    it 'builds ancestry' do
      described_class.import_all_from_sde
      expect(MarketGroup.find(1016).ancestry).to eq('2/211')
    end
  end
end
