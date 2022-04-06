# frozen_string_literal: true

# ## Schema Information
#
# Table name: `user_sessions`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `uuid`             | `not null, primary key`
# **`identity_id`**  | `bigint`           | `not null`
# **`session_id`**   | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_unique_user_sessions` (_unique_):
#     * **`session_id`**
#     * **`identity_id`**
# * `index_user_sessions_on_identity_id`:
#     * **`identity_id`**
# * `index_user_sessions_on_session_id`:
#     * **`session_id`**
#
FactoryBot.define do
  factory :user_session do
  end
end
