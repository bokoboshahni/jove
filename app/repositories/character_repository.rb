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
end
