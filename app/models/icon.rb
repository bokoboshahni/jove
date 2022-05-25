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
class Icon < ApplicationRecord
  include SDEImportable

  self.sde_rename = { icon_file: :file }

  has_many :bloodlines
  has_many :categories
  has_many :corporations
  has_many :factions
  has_many :groups
  has_many :market_groups
  has_many :meta_groups
  has_many :races
  has_many :types

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/iconIDs.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
