# frozen_string_literal: true

# ## Schema Information
#
# Table name: `bloodlines`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`charisma`**        | `integer`          | `not null`
# **`description`**     | `text`             | `not null`
# **`intelligence`**    | `integer`          | `not null`
# **`memory`**          | `integer`          | `not null`
# **`name`**            | `text`             | `not null`
# **`perception`**      | `integer`          | `not null`
# **`willpower`**       | `integer`          | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`corporation_id`**  | `bigint`           | `not null`
# **`icon_id`**         | `bigint`           |
# **`race_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bloodlines_on_corporation_id`:
#     * **`corporation_id`**
# * `index_bloodlines_on_icon_id`:
#     * **`icon_id`**
# * `index_bloodlines_on_race_id`:
#     * **`race_id`**
#
require 'rails_helper'

RSpec.describe Bloodline, type: :model do
  describe '.import_all_from_sde' do
    let(:bloodline_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/bloodlines.yaml')).keys
    end

    it 'saves each bloodline' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(bloodline_ids)
    end
  end
end
