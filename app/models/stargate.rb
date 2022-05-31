# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stargates`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`name`**             | `text`             | `not null`
# **`position_x`**       | `decimal(, )`      | `not null`
# **`position_y`**       | `decimal(, )`      | `not null`
# **`position_z`**       | `decimal(, )`      | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`destination_id`**   | `bigint`           | `not null`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_stargates_on_destination_id`:
#     * **`destination_id`**
# * `index_stargates_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_stargates_on_type_id`:
#     * **`type_id`**
#
class Stargate < ApplicationRecord
  include SDEImportable
  include Searchable

  multisearchable against: %i[name]

  self.inheritance_column = nil

  belongs_to :solar_system
  belongs_to :destination, class_name: 'Stargate'
  belongs_to :type
end
