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
class PlanetSchematicPin < ApplicationRecord
  self.primary_keys = :schematic_id, :type_id

  belongs_to :schematic, class_name: 'PlanetSchematic'
  belongs_to :type
end
