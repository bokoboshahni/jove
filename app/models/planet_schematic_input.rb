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
class PlanetSchematicInput < ApplicationRecord
  self.primary_keys = :schematic_id, :type_id

  belongs_to :schematic, class_name: 'PlanetSchematic'
  belongs_to :type
end
