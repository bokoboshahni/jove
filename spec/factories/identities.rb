# frozen_string_literal: true

# ## Schema Information
#
# Table name: `identities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`default`**       | `boolean`          |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`user_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_identities_on_character_id` (_unique_):
#     * **`character_id`**
# * `index_identities_on_user_id`:
#     * **`user_id`**
# * `index_unique_default_identities` (_unique_):
#     * **`user_id`**
#     * **`default`**
#
FactoryBot.define do
  factory :identity do
    association :character, factory: :permitted_character
    user
  end
end
