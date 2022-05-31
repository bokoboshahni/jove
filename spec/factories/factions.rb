# frozen_string_literal: true

# ## Schema Information
#
# Table name: `factions`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`description`**             | `text`             | `not null`
# **`log_data`**                | `jsonb`            |
# **`name`**                    | `text`             | `not null`
# **`short_description`**       | `text`             |
# **`size_factor`**             | `decimal(, )`      | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`corporation_id`**          | `bigint`           |
# **`icon_id`**                 | `bigint`           | `not null`
# **`militia_corporation_id`**  | `bigint`           |
# **`solar_system_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_factions_on_corporation_id`:
#     * **`corporation_id`**
# * `index_factions_on_icon_id`:
#     * **`icon_id`**
# * `index_factions_on_militia_corporation_id`:
#     * **`militia_corporation_id`**
# * `index_factions_on_solar_system_id`:
#     * **`solar_system_id`**
#
FactoryBot.define do
  factory :faction do
  end
end
