# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_groups`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`ancestry_depth`**  | `integer`          | `default(0), not null`
# **`description`**     | `text`             |
# **`has_types`**       | `boolean`          | `not null`
# **`log_data`**        | `jsonb`            |
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`icon_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_market_groups_on_ancestry`:
#     * **`ancestry`**
# * `index_market_groups_on_icon_id`:
#     * **`icon_id`**
#
class MarketGroup < ApplicationRecord
  include SDEImportable
  include Searchable

  multisearchable against: %i[name description]

  has_ancestry cache_depth: true

  belongs_to :icon, optional: true
end
