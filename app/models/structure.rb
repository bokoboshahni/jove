# frozen_string_literal: true

# ## Schema Information
#
# Table name: `structures`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`discarded_at`**          | `datetime`         |
# **`esi_etag`**              | `text`             | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`name`**                  | `text`             | `not null`
# **`position_x`**            | `decimal(, )`      | `not null`
# **`position_y`**            | `decimal(, )`      | `not null`
# **`position_z`**            | `decimal(, )`      | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`corporation_id`**        | `bigint`           | `not null`
# **`solar_system_id`**       | `bigint`           | `not null`
# **`type_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_structures_on_corporation_id`:
#     * **`corporation_id`**
# * `index_structures_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_structures_on_type_id`:
#     * **`type_id`**
#
class Structure < ApplicationRecord
  include Auditable
  include Discardable
  include ESIGrantable
  include ESISyncable
  include Searchable

  self.repository = StructureRepository

  multisearchable against: %i[name]

  pg_search_scope :search_by_name, against: %i[name], using: { tsearch: { prefix: true } }

  belongs_to :corporation
  belongs_to :solar_system
  belongs_to :type, optional: true

  has_one :market_order_source, as: :source

  has_one :alliance, through: :corporation

  has_one :constellation, through: :solar_system
  has_one :region, through: :constellation

  has_many :market_locations, as: :location
  has_many :markets, through: :market_locations

  delegate :name, to: :corporation, prefix: true
  delegate :name, to: :alliance, prefix: true, allow_nil: true
  delegate :name, to: :solar_system, prefix: true

  def enable_market_source(requester, token_param)
    esi_token = build_token(requester, token_param)

    transaction do
      esi_token.save!
      create_market_order_source!
    end

    esi_token
  end

  private

  def build_token(requester, token_param)
    ESIToken.new(
      token_param.merge(
        requester:,
        scopes: ESIGrant::StructureMarket.requested_scopes,
        grants_attributes: [{ requester:, grantable: self, type: 'ESIGrant::StructureMarket' }]
      )
    )
  end
end
