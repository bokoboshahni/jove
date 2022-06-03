# frozen_string_literal: true

class CharacterRepository < ApplicationRepository
  class ESIGateway
    include ESIRepositoryGateway

    self.model = Character
    self.path = Addressable::Template.new('characters/{id}/')
    self.mapper = lambda do |data|
      data.delete('alliance_id')
    end
  end

  def initialize(gateway: nil)
    super(gateway:)

    @gateway ||= ESIGateway.new
  end
end
