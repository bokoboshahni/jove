# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`log_data`**      | `jsonb`            |
# **`time`**          | `interval`         | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#
FactoryBot.define do
  factory :blueprint_activity do
  end
end
