# frozen_string_literal: true

# ## Schema Information
#
# Table name: `blueprint_activity_skills`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`activity`**      | `enum`             | `not null, primary key`
# **`level`**         | `integer`          | `not null`
# **`log_data`**      | `jsonb`            |
# **`blueprint_id`**  | `bigint`           | `not null, primary key`
# **`skill_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activity_skills_on_skill_id`:
#     * **`skill_id`**
# * `index_unique_blueprint_activity_skills` (_unique_):
#     * **`blueprint_id`**
#     * **`activity`**
#     * **`skill_id`**
#
class BlueprintActivitySkill < ApplicationRecord
  include BlueprintActivityItem

  self.primary_keys = :blueprint_id, :activity, :skill_id

  belongs_to :skill, class_name: 'Type'
end
