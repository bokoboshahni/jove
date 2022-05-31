# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematic_pins`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`log_data`**      | `jsonb`            |
# **`schematic_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**       | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_planet_schematic_pins` (_unique_):
#     * **`schematic_id`**
#     * **`type_id`**
#
FactoryBot.define do
  factory :planet_schematic_pin do
  end
end
