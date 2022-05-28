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
end
