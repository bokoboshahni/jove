# frozen_string_literal: true

# ## Schema Information
#
# Table name: `dogma_categories`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe DogmaCategory, type: :model do
  describe '.import_all_from_sde' do
    let(:dogma_category_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/dogmaAttributeCategories.yaml')).keys
    end

    it 'saves each dogma category' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(dogma_category_ids)
    end
  end
end
