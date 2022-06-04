# frozen_string_literal: true

require 'jove/esi/scopes'

# ## Schema Information
#
# Table name: `esi_tokens`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`access_token`**               | `text`             |
# **`approved_at`**                | `datetime`         |
# **`authorized_at`**              | `datetime`         |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`refresh_error_code`**         | `text`             |
# **`refresh_error_description`**  | `text`             |
# **`refresh_error_status`**       | `integer`          |
# **`refresh_token`**              | `text`             |
# **`refreshed_at`**               | `datetime`         |
# **`rejected_at`**                | `datetime`         |
# **`revoked_at`**                 | `datetime`         |
# **`scopes`**                     | `text`             | `not null, is an Array`
# **`status`**                     | `enum`             | `not null`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`identity_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_esi_tokens_on_identity_id`:
#     * **`identity_id`**
# * `index_esi_tokens_on_requester_id`:
#     * **`requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`identity_id => identities.id`**
# * `fk_rails_...`:
#     * **`requester_id => identities.id`**
#
class ESIToken < ApplicationRecord # rubocop:disable Metrics/ClassLength
  include AASM

  belongs_to :identity
  belongs_to :requester, class_name: 'Identity'

  has_one :character, through: :identity
  has_one :user, through: :identity

  has_many :grants, class_name: 'ESIGrant', foreign_key: :token_id, dependent: :destroy

  delegate :expired?, to: :current_token, prefix: true, allow_nil: true
  delegate :name, to: :character

  encrypts :access_token, deterministic: true
  encrypts :refresh_token, deterministic: true

  validates :grants, length: { minimum: 1 }

  validates :access_token, presence: true, if: -> { authorized? }
  validates :refresh_token, presence: true, if: -> { authorized? }
  validates :expires_at, presence: true, if: -> { authorized? }

  validates :identity_id, uniqueness: { scope: %i[scopes status] }

  validates_associated :grants

  accepts_nested_attributes_for :grants

  scope :active, -> { where.not(status: %i[approved rejected requested revoked]) }

  enum :status, %i[
    requested
    approved
    rejected
    authorized
    revoked
    expired
  ].index_with(&:to_s)

  aasm column: :status, enum: true, timestamps: true, whiny_persistence: false do # rubocop:disable Metrics/BlockLength
    state :requested, initial: true
    state :approved, :rejected, :authorized, :revoked, :expired

    event :approve do
      transitions from: :requested, to: :approved

      after { approve_grants }
    end

    event :reject do
      transitions from: :requested, to: :rejected

      after { reject_grants }
    end

    event :authorize do
      transitions from: :approved, to: :authorized do
        guard { |auth| auth_matches_token?(auth) }
      end

      before { |auth| assign_access_token(auth.credentials) }
    end

    event :expire do
      transitions from: :authorized, to: :expired

      before { |e| assign_refresh_error!(e) }
    end

    event :renew do
      transitions from: :expired, to: :authorized do
        guard { |auth| auth_matches_token?(auth) }
      end

      before { |auth| assign_access_token(auth.credentials) }
    end

    event :revoke do
      transitions from: %i[authorized expired], to: :revoked
    end
  end

  def authorize_url(redirect_uri, state)
    Jove.config.esi_oauth_client.auth_code.authorize_url(redirect_uri:, scope: scopes.join(' '), state:)
  end

  def refresh!
    return true unless current_token.expired?

    Retriable.retriable(on: [OAuth2::Error], tries: Rails.env.test? ? 1 : 3) do
      assign_access_token(current_token.refresh!)
      save!
    end

    true
  rescue OAuth2::Error => e
    expire!(e)
    false
  end

  def to_oauth_token
    return unless authorized?

    OAuth2::AccessToken.from_hash(Jove.config.esi_oauth_client, access_token:, refresh_token:, expires_at:)
  end
  alias current_token to_oauth_token

  private

  delegate :esi_client_id, :esi_client_secret, :esi_oauth_url, to: :jove_config

  def auth_matches_token?(auth)
    scopes == auth.info.scopes.split &&
      identity == Identity.find_by(character_id: auth.uid)
  end

  def approve_grants
    grants.each(&:approve!)
  end

  def reject_grants
    grants.each(&:reject!)
  end

  def assign_access_token(token)
    assign_attributes(
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_at: Time.zone.at(token.expires_at).to_datetime,
      refreshed_at: Time.zone.now
    )
  end

  def assign_refresh_error!(err)
    assign_attributes(
      access_token: nil,
      refresh_token: nil,
      expires_at: nil,
      refresh_error_code: err.code,
      refresh_error_description: err.description,
      refresh_error_status: err.response.status,
      refreshed_at: Time.zone.now
    )
  end
end
