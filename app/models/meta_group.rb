# frozen_string_literal: true

# ## Schema Information
#
# Table name: `meta_groups`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint`           | `not null, primary key`
# **`description`**  | `text`             |
# **`icon_suffix`**  | `text`             |
# **`log_data`**     | `jsonb`            |
# **`name`**         | `text`             | `not null`
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`icon_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_meta_groups_on_icon_id`:
#     * **`icon_id`**
#
class MetaGroup < ApplicationRecord
  include SDEImportable
  include Searchable

  multisearchable against: %i[name description]

  belongs_to :icon, optional: true

  has_many :types
end
