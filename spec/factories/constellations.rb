# frozen_string_literal: true

# ## Schema Information
#
# Table name: `constellations`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`center_x`**           | `decimal(, )`      | `not null`
# **`center_y`**           | `decimal(, )`      | `not null`
# **`center_z`**           | `decimal(, )`      | `not null`
# **`log_data`**           | `jsonb`            |
# **`max_x`**              | `decimal(, )`      | `not null`
# **`max_y`**              | `decimal(, )`      | `not null`
# **`max_z`**              | `decimal(, )`      | `not null`
# **`min_x`**              | `decimal(, )`      | `not null`
# **`min_y`**              | `decimal(, )`      | `not null`
# **`min_z`**              | `decimal(, )`      | `not null`
# **`name`**               | `text`             | `not null`
# **`radius`**             | `decimal(, )`      | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`faction_id`**         | `bigint`           |
# **`region_id`**          | `bigint`           | `not null`
# **`wormhole_class_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_constellations_on_faction_id`:
#     * **`faction_id`**
# * `index_constellations_on_region_id`:
#     * **`region_id`**
# * `index_constellations_on_wormhole_class_id`:
#     * **`wormhole_class_id`**
#
FactoryBot.define do
  factory :constellation do
    region

    center_x { Faker::Number.decimal }
    center_y { Faker::Number.decimal }
    center_z { Faker::Number.decimal }
    max_x { Faker::Number.decimal }
    max_y { Faker::Number.decimal }
    max_z { Faker::Number.decimal }
    min_x { Faker::Number.decimal }
    min_y { Faker::Number.decimal }
    min_z { Faker::Number.decimal }
    radius { Faker::Number.decimal }
    name { Faker::Space.nebula }
  end
end
