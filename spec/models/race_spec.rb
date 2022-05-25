# frozen_string_literal: true

# ## Schema Information
#
# Table name: `races`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`description`**   | `text`             |
# **`name`**          | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`icon_id`**       | `bigint`           |
# **`ship_type_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_races_on_icon_id`:
#     * **`icon_id`**
# * `index_races_on_ship_type_id`:
#     * **`ship_type_id`**
#
require 'rails_helper'

RSpec.describe Race, type: :model do
  describe '.import_all_from_sde' do
    let(:race_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/races.yaml')).keys
    end

    it 'saves each race' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(race_ids)
    end
  end
end
