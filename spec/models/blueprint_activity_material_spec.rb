# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activity_materials`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`log_data`**      | `jsonb`            |
# **`quantity`**      | `integer`          | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
# **`material_id`**   | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activity_materials_on_material_id`:
#     * **`material_id`**
# * `index_unique_blueprint_activity_materials` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#     * **`material_id`**
#
require 'rails_helper'

RSpec.describe BlueprintActivityMaterial, type: :model do
end
