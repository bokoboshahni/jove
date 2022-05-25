# frozen_string_literal: true

# ## Schema Information
#
# Table name: `icons`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`file`**         | `text`             | `not null`
# **`obsolete`**     | `boolean`          |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe Icon, type: :model do
  describe '.import_all_from_sde' do
    let(:icon_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/iconIDs.yaml')).keys
    end

    it 'saves each icon' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(icon_ids)
    end
  end
end
