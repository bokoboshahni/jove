# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematics`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`log_data`**         | `jsonb`            |
# **`name`**             | `text`             | `not null`
# **`output_quantity`**  | `integer`          | `not null`
# **`pins`**             | `integer`          | `not null, is an Array`
# **`time`**             | `interval`         | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`output_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_planet_schematics_on_output_id`:
#     * **`output_id`**
#
FactoryBot.define do
  factory :planet_schematic do
  end
end
