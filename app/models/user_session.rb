# frozen_string_literal: true

class UserSession
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :identity

  delegate :user, to: :identity

  validate :validate_login_permitted

  def self.from_sso!(auth)
    character = Character.from_esi(auth.uid)
    identity = Identity.find_by(character:)

    unless identity
      identity = Identity.new(character:, default: true)
      identity.build_user
      identity.save
    end

    session = new(identity:)
    session.validate
    session
  end

  private

  def validate_login_permitted
    return if identity.valid_for_login?

    errors.add(:base, :not_permitted)
  end
end
