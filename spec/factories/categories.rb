# frozen_string_literal: true

# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`published`**   | `boolean`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`icon_id`**     | `bigint`           |
#
# ### Indexes
#
# * `index_categories_on_icon_id`:
#     * **`icon_id`**
#
FactoryBot.define do
  factory :category do
  end
end
