# frozen_string_literal: true

# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`published`**   | `boolean`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`icon_id`**     | `bigint`           |
#
# ### Indexes
#
# * `index_categories_on_icon_id`:
#     * **`icon_id`**
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '.import_all_from_sde' do
    let(:category_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/categoryIDs.yaml')).keys
    end

    it 'saves each category' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(category_ids)
    end
  end
end
