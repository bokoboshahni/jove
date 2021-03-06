# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`log_data`**      | `jsonb`            |
# **`time`**          | `interval`         | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#
class BlueprintActivity < ApplicationRecord
  include BlueprintActivityEnum
  include SDEImportable

  self.primary_keys = :blueprint_id, :activity

  belongs_to :blueprint, class_name: 'Type'

  has_many :materials, class_name: 'BlueprintActivityMaterial',
                       foreign_key: %i[blueprint_id activity]
  has_many :products, class_name: 'BlueprintActivityProduct',
                      foreign_key: %i[blueprint_id activity]
  has_many :skills, class_name: 'BlueprintActivitySkill',
                    foreign_key: %i[blueprint_id activity]
end
