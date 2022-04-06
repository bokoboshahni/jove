# frozen_string_literal: true

class AllianceRepository < ApplicationRepository
  class ESIGateway
    include ESIRepositoryGateway

    self.model = Alliance
    self.path = Addressable::Template.new('alliances/{id}/')
    self.mapper = lambda do |data|
      data['founded_on'] = Date.parse(data.delete('date_founded'))
    end
  end
end
