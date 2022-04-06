# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`admin`**       | `boolean`          |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class User < ApplicationRecord
  devise :omniauthable, :timeoutable

  has_one :default_identity, lambda {
                               where(default: true)
                             }, class_name: 'Identity'

  has_one :default_character, class_name: 'Character', through: :default_identity, source: :character

  has_one :default_alliance, class_name: 'Alliance', through: :default_character, source: :alliance
  has_one :default_corporation, class_name: 'Corporation', through: :default_character, source: :corporation

  has_many :identities, dependent: :delete_all

  has_many :login_activities, through: :identities
  has_many :characters, through: :identities
  has_many :user_sessions, through: :identities

  has_many :corporations, through: :characters

  has_many :alliances, through: :corporations

  delegate :avatar_url, to: :default_character
  delegate :name, to: :default_identity
  delegate :name, to: :default_corporation, prefix: true
  delegate :name, to: :default_alliance, prefix: true, allow_nil: true

  attr_accessor :destroyer

  before_destroy :check_admin_count_for_destroy
  before_destroy :check_destroyer_for_destroy

  def create_identity_from_sso!(auth)
    character = Character.from_esi(auth.uid)
    identities.create(character:)
  end

  def last_successful_login_time
    login_activities.order(created_at: :desc).first&.created_at
  end

  def change_default_identity!(identity)
    transaction do
      default_identity.update!(default: nil)
      identity.update!(default: true)
    end
  end

  private

  def check_destroyer_for_destroy
    return unless destroyer

    return unless destroyer == self

    errors.add(:base, :cannot_destroy_self)
    throw(:abort)
  end

  def check_admin_count_for_destroy
    return unless admin?

    return if User.where(admin: true).count > 1

    errors.add(:base, :cannot_destroy_only_admin)
    throw(:abort)
  end
end
