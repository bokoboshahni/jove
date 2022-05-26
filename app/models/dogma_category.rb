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
class DogmaCategory < ApplicationRecord
  include SDEImportable

  has_many :dogma_attributes, foreign_key: :category_id
  has_many :dogma_effects, foreign_key: :category_id

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/dogmaAttributeCategories.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end
end
