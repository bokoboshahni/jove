# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematic_pins`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`schematic_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**       | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_planet_schematic_pins` (_unique_):
#     * **`schematic_id`**
#     * **`type_id`**
#
require 'rails_helper'

RSpec.describe PlanetSchematicPin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
