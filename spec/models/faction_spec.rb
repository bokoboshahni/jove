# frozen_string_literal: true

# ## Schema Information
#
# Table name: `factions`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`description`**             | `text`             | `not null`
# **`name`**                    | `text`             | `not null`
# **`short_description`**       | `text`             |
# **`size_factor`**             | `decimal(, )`      | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`corporation_id`**          | `bigint`           |
# **`icon_id`**                 | `bigint`           | `not null`
# **`militia_corporation_id`**  | `bigint`           |
# **`solar_system_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_factions_on_corporation_id`:
#     * **`corporation_id`**
# * `index_factions_on_icon_id`:
#     * **`icon_id`**
# * `index_factions_on_militia_corporation_id`:
#     * **`militia_corporation_id`**
# * `index_factions_on_solar_system_id`:
#     * **`solar_system_id`**
#
require 'rails_helper'

RSpec.describe Faction, type: :model do
  describe '.import_all_from_sde' do
    let(:faction_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/factions.yaml')).keys
    end

    it 'saves each faction' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(faction_ids)
    end
  end
end
