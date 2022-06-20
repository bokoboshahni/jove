# frozen_string_literal: true

# ## Schema Information
#
# Table name: `characters`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`birthday`**              | `date`             | `not null`
# **`description`**           | `text`             |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`gender`**                | `text`             | `not null`
# **`name`**                  | `text`             | `not null`
# **`owner_hash`**            | `text`             |
# **`security_status`**       | `decimal(, )`      |
# **`title`**                 | `text`             |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`bloodline_id`**          | `bigint`           | `not null`
# **`corporation_id`**        | `bigint`           | `not null`
# **`faction_id`**            | `bigint`           |
# **`race_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_characters_on_bloodline_id`:
#     * **`bloodline_id`**
# * `index_characters_on_corporation_id`:
#     * **`corporation_id`**
# * `index_characters_on_faction_id`:
#     * **`faction_id`**
# * `index_characters_on_race_id`:
#     * **`race_id`**
#
class Character < ApplicationRecord
  include ESISyncable
  include Searchable

  multisearchable against: %i[name description]

  belongs_to :bloodline, optional: true
  belongs_to :corporation, optional: true
  belongs_to :race, optional: true

  has_one :corporation_as_ceo, class_name: 'Corporation', foreign_key: :ceo_id
  has_one :identity
  has_one :login_permit, as: :permittable

  has_one :alliance, through: :corporation
  has_one :user, through: :identity

  has_many :alliances_as_creator, class_name: 'Alliance', foreign_key: :creator_id
  has_many :corporations_as_creator, class_name: 'Corporation', foreign_key: :creator_id

  has_one :last_successful_login, through: :identity

  delegate :name, to: :corporation, prefix: true
  delegate :name, to: :alliance, prefix: true, allow_nil: true

  validates :birthday, presence: true
  validates :bloodline_id, presence: true
  validates :corporation_id, presence: true
  validates :esi_etag, presence: true
  validates :esi_expires_at, presence: true
  validates :esi_last_modified_at, presence: true
  validates :gender, presence: true
  validates :name, presence: true
  validates :race_id, presence: true

  def self.from_esi(id)
    character_repository = CharacterRepository.new(gateway: CharacterRepository::ESIGateway.new)
    character_repository.find(id)
  end

  def avatar_url
    "https://images.evetech.net/characters/#{id}/portrait"
  end
end
