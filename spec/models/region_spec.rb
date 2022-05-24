# frozen_string_literal: true

# ## Schema Information
#
# Table name: `regions`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`center_x`**           | `decimal(, )`      | `not null`
# **`center_y`**           | `decimal(, )`      | `not null`
# **`center_z`**           | `decimal(, )`      | `not null`
# **`description`**        | `text`             |
# **`max_x`**              | `decimal(, )`      | `not null`
# **`max_y`**              | `decimal(, )`      | `not null`
# **`max_z`**              | `decimal(, )`      | `not null`
# **`min_x`**              | `decimal(, )`      | `not null`
# **`min_y`**              | `decimal(, )`      | `not null`
# **`min_z`**              | `decimal(, )`      | `not null`
# **`name`**               | `text`             | `not null`
# **`universe`**           | `enum`             | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`faction_id`**         | `bigint`           |
# **`nebula_id`**          | `bigint`           |
# **`wormhole_class_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_regions_on_faction_id`:
#     * **`faction_id`**
# * `index_regions_on_nebula_id`:
#     * **`nebula_id`**
# * `index_regions_on_wormhole_class_id`:
#     * **`wormhole_class_id`**
#
require 'rails_helper'

RSpec.describe Region, type: :model do
  describe '.import_all_from_sde' do
    let(:region_data) do
      Dir[File.join(Jove.config.sde_path, 'fsd/universe/**/region.staticdata')].map do |region_path|
        YAML.load_file(region_path)
      end
    end

    let(:region_ids) { region_data.map { |r| r['regionID'] } }

    it 'saves each region' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(region_ids)
    end
  end

  describe '.import_from_sde' do
    it 'saves the region' do
      expect(described_class.import_from_sde('TheForge')).to be_persisted
    end
  end
end
