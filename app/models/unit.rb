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
end
