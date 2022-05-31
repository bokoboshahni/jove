# frozen_string_literal: true

# ## Schema Information
#
# Table name: `planet_schematic_inputs`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`log_data`**      | `jsonb`            |
# **`quantity`**      | `integer`          | `not null`
# **`schematic_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**       | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_planet_schematic_inputs` (_unique_):
#     * **`schematic_id`**
#     * **`type_id`**
#
require 'rails_helper'

RSpec.describe PlanetSchematicInput, type: :model do
end
