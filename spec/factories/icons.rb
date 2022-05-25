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
FactoryBot.define do
  factory :icon do
  end
end
