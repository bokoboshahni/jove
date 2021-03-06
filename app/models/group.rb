# frozen_string_literal: true

# ## Schema Information
#
# Table name: `groups`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`anchorable`**              | `boolean`          | `not null`
# **`anchored`**                | `boolean`          | `not null`
# **`fittable_non_singleton`**  | `boolean`          | `not null`
# **`log_data`**                | `jsonb`            |
# **`name`**                    | `text`             | `not null`
# **`published`**               | `boolean`          | `not null`
# **`use_base_price`**          | `boolean`          | `not null`
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`category_id`**             | `bigint`           | `not null`
# **`icon_id`**                 | `bigint`           |
#
# ### Indexes
#
# * `index_groups_on_category_id`:
#     * **`category_id`**
# * `index_groups_on_icon_id`:
#     * **`icon_id`**
#
class Group < ApplicationRecord
  include SDEImportable
  include Searchable

  multisearchable against: %i[name]

  belongs_to :category
  belongs_to :icon, optional: true
end
