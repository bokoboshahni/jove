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
require 'rails_helper'

RSpec.describe PlanetSchematicInput, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
