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
# **`log_data`**     | `jsonb`            |
# **`obsolete`**     | `boolean`          |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
class Icon < ApplicationRecord
  include SDEImportable

  has_many :bloodlines
  has_many :categories
  has_many :corporations
  has_many :dogma_attributes
  has_many :dogma_effects
  has_many :factions
  has_many :groups
  has_many :market_groups
  has_many :meta_groups
  has_many :races
  has_many :types
end
