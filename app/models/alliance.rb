# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                           | Type               | Attributes
# ------------------------------ | ------------------ | ---------------------------
# **`id`**                       | `bigint`           | `not null, primary key`
# **`esi_etag`**                 | `text`             | `not null`
# **`esi_expires_at`**           | `datetime`         | `not null`
# **`esi_last_modified_at`**     | `datetime`         | `not null`
# **`founded_on`**               | `date`             | `not null`
# **`name`**                     | `text`             | `not null`
# **`ticker`**                   | `text`             | `not null`
# **`created_at`**               | `datetime`         | `not null`
# **`updated_at`**               | `datetime`         | `not null`
# **`creator_corporation_id`**   | `bigint`           | `not null`
# **`creator_id`**               | `bigint`           | `not null`
# **`executor_corporation_id`**  | `bigint`           |
# **`faction_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_alliances_on_creator_corporation_id`:
#     * **`creator_corporation_id`**
# * `index_alliances_on_creator_id`:
#     * **`creator_id`**
# * `index_alliances_on_executor_corporation_id`:
#     * **`executor_corporation_id`**
# * `index_alliances_on_faction_id`:
#     * **`faction_id`**
#
class Alliance < ApplicationRecord
  include ESISyncable
  include Searchable

  multisearchable against: %i[name ticker]

  belongs_to :creator, class_name: 'Character', optional: true
  belongs_to :creator_corporation, class_name: 'Corporation', optional: true

  has_one :login_permit, as: :permittable

  has_many :corporations

  has_many :characters, through: :corporations

  has_many :markets, as: :owner

  has_many :users, through: :characters

  def avatar_url
    "https://images.evetech.net/alliances/#{id}/logo"
  end
end
