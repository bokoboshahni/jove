# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematic_inputs`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`quantity`**      | `integer`          | `not null`
# **`schematic_id`**  | `bigint`           | `not null`
# **`type_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_planet_schematic_inputs` (_unique_):
#     * **`schematic_id`**
#     * **`type_id`**
#
FactoryBot.define do
  factory :planet_schematic_input do
  end
end
