# frozen_string_literal: true

class CorporationRepository < ApplicationRepository
  class ESIGateway
    include ESIRepositoryGateway

    self.model = Corporation
    self.path = Addressable::Template.new('corporations/{id}/')
    self.mapper = lambda do |data|
      if data['alliance_id']
        data['alliance_id'] =
          AllianceRepository.new(gateway: AllianceRepository::ESIGateway.new)
                            .find(data.delete('alliance_id')).id
      end

      data['founded_on'] = Date.parse(data.delete('date_founded')) if data['date_founded']
      data['share_count'] = data.delete('shares')
    end
  end

  def initialize(gateway: nil)
    super(gateway:)

    @gateway ||= ESIGateway.new
  end
end
