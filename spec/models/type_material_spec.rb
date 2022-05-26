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
require 'rails_helper'

RSpec.describe TypeMaterial, type: :model do
  describe '.import_all_from_sde' do
    let(:type_material_ids) do
      YAML.load_file(File.join(Jove.config.sde_path, 'fsd/typeMaterials.yaml')).each_with_object([]) do |(id, type), a|
        type['materials'].each { |m| a << [id, m['materialTypeID']] }
      end
    end

    it 'saves each type material' do
      expect(described_class.import_all_from_sde.rows).to match_array(type_material_ids)
    end
  end
end
