# frozen_string_literal: true

module ESISyncable
  extend ActiveSupport::Concern

  included do
    class_attribute :repository
  end

  module ClassMethods
    def sync_from_esi!(id)
      repository.new.find(id)
    end
  end

  def esi_expired?
    return true unless esi_expires_at

    esi_expires_at.to_i <= Time.zone.now.to_i
  end

  def sync_from_esi!
    repository.new.find(id)
  end
end
