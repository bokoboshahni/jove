# frozen_string_literal: true

# ## Schema Information
#
# Table name: `graphics`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`description`**        | `text`             |
# **`graphic_file`**       | `text`             |
# **`icon_folder`**        | `text`             |
# **`skin_faction_name`**  | `text`             |
# **`skin_hull_name`**     | `text`             |
# **`skin_race_name`**     | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
#
FactoryBot.define do
  factory :graphic do
  end
end
