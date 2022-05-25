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
class Corporation < ApplicationRecord
  include ESISyncable
  include SDEImportable

  self.sde_mapper = lambda { |data, **_kwargs|
    data[:npc] = true
  }

  self.sde_exclude = %i[
    allowed_member_races
    corporation_trades
    divisions
    exchange_rates
    has_player_personnel_manager
    initial_price
    investors
    lp_offer_tables
    member_limit
    min_security
    minimum_join_standing
    public_shares
    send_char_termination_message
    unique_name
  ]

  self.sde_rename = {
    shares: :share_count,
    station_id: :home_station_id,
    ticker_name: :ticker
  }

  self.sde_localized = %i[description name]

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

  def self.import_all_from_sde(progress: nil)
    data = YAML.load_file(File.join(sde_path, 'fsd/npcCorporations.yaml'))
    progress&.update(total: data.count)
    rows = data.map do |id, orig|
      record = map_sde_attributes(orig, id:)
      progress&.advance
      record
    end
    upsert_all(rows)
  end

  def avatar_url
    "https://images.evetech.net/corporations/#{id}/logo"
  end
end
