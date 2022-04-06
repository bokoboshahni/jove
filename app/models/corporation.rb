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
class Corporation < ApplicationRecord
  include ESISyncable

  belongs_to :alliance, optional: true

  has_one :login_permit, as: :permittable

  has_many :alliances_as_creator, class_name: 'Alliance',
                                  foreign_key: :creator_corporation_id
  has_many :alliances_as_executor, class_name: 'Alliance',
                                   foreign_key: :executor_corporation_id
  has_many :character_corporation_histories, class_name: 'Character::CorporationHistory'
  has_many :characters

  has_many :historical_characters, class_name: 'Character', through: :character_corporation_histories,
                                   source: :character
  has_many :users, through: :characters

  delegate :name, to: :alliance, prefix: true, allow_nil: true

  def avatar_url
    "https://images.evetech.net/corporations/#{id}/logo"
  end
end
