# frozen_string_literal: true

# ## Schema Information
#
# Table name: `type_materials`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`log_data`**     | `jsonb`            |
# **`quantity`**     | `integer`          | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`material_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_type_materials` (_unique_):
#     * **`type_id`**
#     * **`material_id`**
#
require 'rails_helper'

RSpec.describe TypeMaterial, type: :model do
end
