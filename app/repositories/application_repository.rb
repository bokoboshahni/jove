# frozen_string_literal: true

class ApplicationRepository
  delegate :find, :find_by, :search, to: :gateway

  def initialize(gateway:)
    @gateway = gateway
  end

  private

  attr_reader :gateway
end
