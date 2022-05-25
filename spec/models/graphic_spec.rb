# frozen_string_literal: true

# ## Schema Information
#
# Table name: `graphics`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`description`**        | `text`             |
# **`graphic_file`**       | `text`             |
# **`icon_folder`**        | `text`             |
# **`skin_faction_name`**  | `text`             |
# **`skin_hull_name`**     | `text`             |
# **`skin_race_name`**     | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe Graphic, type: :model do
  describe '.import_all_from_sde' do
    let(:graphic_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/graphicIDs.yaml')).keys
    end

    it 'saves each graphic' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(graphic_ids)
    end
  end
end
