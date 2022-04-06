# frozen_string_literal: true

module ESISyncable
  extend ActiveSupport::Concern

  def esi_expired?
    return true unless esi_expires_at

    esi_expires_at.to_i <= Time.zone.now.to_i
  end
end
