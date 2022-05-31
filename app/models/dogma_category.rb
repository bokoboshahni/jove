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
# **`log_data`**     | `jsonb`            |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
class DogmaCategory < ApplicationRecord
  include SDEImportable
  include Searchable

  multisearchable against: %i[name description]

  has_many :dogma_attributes, foreign_key: :category_id
  has_many :dogma_effects, foreign_key: :category_id
end
