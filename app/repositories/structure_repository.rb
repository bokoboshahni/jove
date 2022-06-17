# frozen_string_literal: true

class StructureRepository < ApplicationRepository
  class ESIGateway
    include ESIRepositoryGateway

    self.authorization_type = :structure_discovery
    self.model = Structure
    self.path = Addressable::Template.new('universe/structures/{id}/')
    self.mapper = lambda do |data|
      data['corporation_id'] =
        CorporationRepository.new(gateway: CorporationRepository::ESIGateway.new).find(data.delete('owner_id')).id
      position = data.delete('position')
      if position
        data['position_x'] = position['x']
        data['position_y'] = position['y']
        data['position_z'] = position['z']
      end
    end
  end

  def initialize(gateway: nil)
    super(gateway:)

    @gateway ||= ESIGateway.new
  end
end
