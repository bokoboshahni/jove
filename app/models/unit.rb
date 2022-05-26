# frozen_string_literal: true

require 'csv'

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
class Unit < ApplicationRecord
  belongs_to :icon, optional: true
  belongs_to :ship_type, class_name: 'Type', optional: true

  has_many :dogma_attributes
  has_many :types

  def self.import_all_from_sde(progress: nil)
    data = CSV.read(Rails.root.join('db/units.csv'), headers: true)
    progress&.update(total: data.count)
    rows = data.map do |orig|
      record = { id: orig.fetch('unitID'), name: orig.fetch('unitName') }
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
