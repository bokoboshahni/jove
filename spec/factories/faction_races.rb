# frozen_string_literal: true

# ## Schema Information
#
# Table name: `faction_races`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`log_data`**    | `jsonb`            |
# **`faction_id`**  | `bigint`           | `not null, primary key`
# **`race_id`**     | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_faction_races_on_race_id`:
#     * **`race_id`**
# * `index_unique_faction_races` (_unique_):
#     * **`faction_id`**
#     * **`race_id`**
#
FactoryBot.define do
  factory :faction_race do
  end
end
