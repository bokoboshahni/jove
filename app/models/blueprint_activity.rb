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
# **`time`**          | `interval`         | `not null`
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activities_on_blueprint_id`:
#     * **`blueprint_id`**
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#
class BlueprintActivity < ApplicationRecord
  include BlueprintActivityEnum

  self.primary_keys = :blueprint_id, :activity

  belongs_to :blueprint, class_name: 'Type'

  has_many :materials, class_name: 'BlueprintActivityMaterial',
                       foreign_key: %i[blueprint_id activity]
  has_many :products, class_name: 'BlueprintActivityProduct',
                      foreign_key: %i[blueprint_id activity]
  has_many :skills, class_name: 'BlueprintActivitySkill',
                    foreign_key: %i[blueprint_id activity]
end
