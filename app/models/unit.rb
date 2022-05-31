# frozen_string_literal: true

require 'csv'

# ## Schema Information
#
# Table name: `units`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`description`**   | `text`             |
# **`display_name`**  | `text`             |
# **`log_data`**      | `jsonb`            |
# **`name`**          | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
#
class Unit < ApplicationRecord
  include SDEImportable

  belongs_to :icon, optional: true
  belongs_to :ship_type, class_name: 'Type', optional: true

  has_many :dogma_attributes
  has_many :types
end
