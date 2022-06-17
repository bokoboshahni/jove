# frozen_string_literal: true

# ## Schema Information
#
# Table name: `identities`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`default`**       | `boolean`          |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`user_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_identities_on_character_id` (_unique_):
#     * **`character_id`**
# * `index_unique_default_identities` (_unique_):
#     * **`user_id`**
#     * **`default`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
class Identity < ApplicationRecord
  include PgSearch::Model

  belongs_to :character
  belongs_to :user

  has_one :corporation, through: :character

  has_one :alliance, through: :corporation

  has_one :last_successful_login, lambda {
                                    where(success: true).order(created_at: :desc)
                                  }, class_name: 'LoginActivity', as: :user

  has_many :esi_tokens
  has_many :requested_esi_tokens, class_name: 'ESIToken', foreign_key: :requester_id
  has_many :login_activities, as: :user

  validates :character_id, uniqueness: true
  validates :default, uniqueness: { scope: :user_id }, allow_blank: true

  validate :validate_login_permitted, on: :create

  delegate :avatar_url, :name, to: :character
  delegate :name, to: :corporation, prefix: true
  delegate :name, to: :alliance, prefix: true

  before_destroy :check_default_identity_for_destroy

  pg_search_scope :search_by_name, associated_against: { character: %i[name] }, using: { tsearch: { prefix: true } }

  def valid_for_login?
    permitted?(character) || (alliance && permitted?(alliance)) || permitted?(corporation)
  end

  private

  def check_default_identity_for_destroy
    return unless default?

    errors.add(:base, :cannot_destroy_default_identity)
    throw(:abort)
  end

  def permitted?(permittable)
    LoginPermit.permitted?(permittable)
  end

  def validate_login_permitted
    return if valid_for_login?

    errors.add(:base, :not_permitted)
  end
end
