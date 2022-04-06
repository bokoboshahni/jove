# frozen_string_literal: true

class CorporationRepository < ApplicationRepository
  class ESIGateway
    include ESIRepositoryGateway

    self.model = Corporation
    self.path = Addressable::Template.new('corporations/{id}/')
    self.mapper = lambda do |data|
      data['founded_on'] = Date.parse(data.delete('date_founded')) if data['date_founded']
      data['share_count'] = data.delete('shares')
    end
  end
end
