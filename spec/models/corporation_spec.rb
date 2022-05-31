# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`deleted`**                | `boolean`          |
# **`description`**            | `text`             |
# **`esi_etag`**               | `text`             |
# **`esi_expires_at`**         | `datetime`         |
# **`esi_last_modified_at`**   | `datetime`         |
# **`extent`**                 | `text`             |
# **`founded_on`**             | `date`             |
# **`log_data`**               | `jsonb`            |
# **`member_count`**           | `integer`          |
# **`name`**                   | `text`             | `not null`
# **`npc`**                    | `boolean`          |
# **`share_count`**            | `bigint`           |
# **`size`**                   | `text`             |
# **`size_factor`**            | `decimal(, )`      |
# **`tax_rate`**               | `decimal(, )`      | `not null`
# **`ticker`**                 | `text`             | `not null`
# **`url`**                    | `text`             |
# **`war_eligible`**           | `boolean`          |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`alliance_id`**            | `bigint`           |
# **`ceo_id`**                 | `bigint`           |
# **`creator_id`**             | `bigint`           |
# **`enemy_id`**               | `bigint`           |
# **`faction_id`**             | `bigint`           |
# **`friend_id`**              | `bigint`           |
# **`home_station_id`**        | `bigint`           |
# **`icon_id`**                | `bigint`           |
# **`main_activity_id`**       | `bigint`           |
# **`race_id`**                | `bigint`           |
# **`secondary_activity_id`**  | `bigint`           |
# **`solar_system_id`**        | `bigint`           |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_corporations_on_ceo_id`:
#     * **`ceo_id`**
# * `index_corporations_on_creator_id`:
#     * **`creator_id`**
# * `index_corporations_on_enemy_id`:
#     * **`enemy_id`**
# * `index_corporations_on_faction_id`:
#     * **`faction_id`**
# * `index_corporations_on_friend_id`:
#     * **`friend_id`**
# * `index_corporations_on_home_station_id`:
#     * **`home_station_id`**
# * `index_corporations_on_icon_id`:
#     * **`icon_id`**
# * `index_corporations_on_main_activity_id`:
#     * **`main_activity_id`**
# * `index_corporations_on_race_id`:
#     * **`race_id`**
# * `index_corporations_on_secondary_activity_id`:
#     * **`secondary_activity_id`**
# * `index_corporations_on_solar_system_id`:
#     * **`solar_system_id`**
#
require 'rails_helper'

RSpec.describe Corporation, type: :model do
end
