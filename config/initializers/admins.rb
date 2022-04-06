# frozen_string_literal: true

Rails.configuration.after_initialize do
  next if Rails.env.test?

  Jove.configuration.admin_character_ids.each do |id|
    character = Character.from_esi(id)
    identity = Identity.find_by(character:)

    LoginPermit.find_or_create_by!(permittable: character)

    unless identity
      identity = Identity.new(character:, default: true)
      identity.build_user(admin: true)
      identity.save!
    end

    Rails.logger.info("Ensured login exists for admin #{character.name} (#{character.id})")
  end
rescue ActiveRecord::NoDatabaseError
  Rails.logger.info('Database is not set up yet')
end
