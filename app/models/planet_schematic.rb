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
class PlanetSchematic < ApplicationRecord
  belongs_to :output, class_name: 'Type'

  has_many :inputs, class_name: 'PlanetSchematicInput', foreign_key: :schematic_id
  has_many :pins, class_name: 'PlanetSchematicPin', foreign_key: :schematic_id
end
