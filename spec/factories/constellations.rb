# frozen_string_literal: true

# ## Schema Information
#
# Table name: `constellations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`center_x`**    | `decimal(, )`      | `not null`
# **`center_y`**    | `decimal(, )`      | `not null`
# **`center_z`**    | `decimal(, )`      | `not null`
# **`max_x`**       | `decimal(, )`      | `not null`
# **`max_y`**       | `decimal(, )`      | `not null`
# **`max_z`**       | `decimal(, )`      | `not null`
# **`min_x`**       | `decimal(, )`      | `not null`
# **`min_y`**       | `decimal(, )`      | `not null`
# **`min_z`**       | `decimal(, )`      | `not null`
# **`name`**        | `text`             | `not null`
# **`radius`**      | `decimal(, )`      | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`region_id`**   | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_constellations_on_region_id`:
#     * **`region_id`**
#
FactoryBot.define do
  factory :constellation do
  end
end
