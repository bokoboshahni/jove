# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`description`**           | `text`             |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`founded_on`**            | `date`             |
# **`member_count`**          | `integer`          | `not null`
# **`name`**                  | `text`             | `not null`
# **`share_count`**           | `integer`          |
# **`tax_rate`**              | `decimal(, )`      | `not null`
# **`ticker`**                | `text`             | `not null`
# **`url`**                   | `text`             |
# **`war_eligible`**          | `boolean`          |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`alliance_id`**           | `bigint`           |
# **`ceo_id`**                | `bigint`           | `not null`
# **`creator_id`**            | `bigint`           | `not null`
# **`faction_id`**            | `bigint`           |
# **`home_station_id`**       | `bigint`           |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_corporations_on_ceo_id`:
#     * **`ceo_id`**
# * `index_corporations_on_creator_id`:
#     * **`creator_id`**
# * `index_corporations_on_faction_id`:
#     * **`faction_id`**
# * `index_corporations_on_home_station_id`:
#     * **`home_station_id`**
#
require 'rails_helper'

RSpec.describe Corporation, type: :model do
end
