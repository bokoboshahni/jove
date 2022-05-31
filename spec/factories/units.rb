# frozen_string_literal: true

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
FactoryBot.define do
  factory :unit do
  end
end
