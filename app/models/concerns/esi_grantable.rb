# frozen_string_literal: true

module ESIGrantable
  extend ActiveSupport::Concern

  included do
    has_many :esi_grants, as: :grantable
  end
end
