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
# **`material_id`**  | `bigint`           | `not null`
# **`type_id`**      | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_type_materials` (_unique_):
#     * **`type_id`**
#     * **`material_id`**
#
class TypeMaterial < ApplicationRecord
  include SDEImportable

  self.primary_keys = :type_id, :material_id

  belongs_to :type
  belongs_to :material, class_name: 'Type'

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/typeMaterials.yaml'))
    progress&.update(total: data.count)
    rows = data.each_with_object([]) do |(id, orig), a|
      orig['materials'].each do |material|
        a << { type_id: id, material_id: material['materialTypeID'], quantity: material['quantity'] }
      end
      progress&.advance
    end
    upsert_all(rows, returning: %i[type_id material_id])
  end
end
