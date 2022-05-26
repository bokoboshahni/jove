# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematic_pins`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`schematic_id`**  | `bigint`           | `not null`
# **`type_id`**       | `bigint`           | `not null`
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
