# frozen_string_literal: true

# ## Schema Information
#
# Table name: `login_permits`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`name`**              | `text`             | `not null`
# **`permittable_type`**  | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`permittable_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_login_permits` (_unique_):
#     * **`permittable_type`**
#     * **`permittable_id`**
#
FactoryBot.define do
  factory :login_permit do
    association :permittable, factory: :character
  end
end
