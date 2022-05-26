# frozen_string_literal: true

# ## Schema Information
#
# Table name: `units`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe '.import_all_from_sde' do
    let(:unit_ids) do
      CSV.read(Rails.root.join('db/units.csv'), headers: true).map { |r| r['unitID'].to_i }
    end

    it 'saves each unit' do
      expect(described_class.import_all_from_sde.rows.flatten).to match_array(unit_ids)
    end
  end
end
