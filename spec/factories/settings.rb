# frozen_string_literal: true

# ## Schema Information
#
# Table name: `settings`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`name`**        | `text`             | `not null, primary key`
# **`value`**       | `text`             |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_unique_settings` (_unique_):
#     * **`name`**
#
FactoryBot.define do
  factory :setting do
  end
end
