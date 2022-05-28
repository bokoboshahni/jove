# frozen_string_literal: true

# ## Schema Information
#
# Table name: `type_materials`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
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
class TypeMaterial < ApplicationRecord
  self.primary_keys = :type_id, :material_id

  belongs_to :type
  belongs_to :material, class_name: 'Type'
end
