# frozen_string_literal: true

# ## Schema Information
#
# Table name: `login_activities`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`context`**         | `text`             |
# **`failure_reason`**  | `text`             |
# **`identity`**        | `text`             |
# **`ip`**              | `text`             |
# **`referrer`**        | `text`             |
# **`scope`**           | `text`             |
# **`strategy`**        | `text`             |
# **`success`**         | `boolean`          |
# **`user_agent`**      | `text`             |
# **`user_type`**       | `string`           |
# **`created_at`**      | `datetime`         | `not null`
# **`user_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_login_activities_on_identity`:
#     * **`identity`**
# * `index_login_activities_on_ip`:
#     * **`ip`**
# * `index_login_activities_on_user`:
#     * **`user_type`**
#     * **`user_id`**
#
FactoryBot.define do
  factory :login_activity do
  end
end
