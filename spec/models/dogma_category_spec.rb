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
require 'rails_helper'

RSpec.describe DogmaCategory, type: :model do
end
