# frozen_string_literal: true

module SDEImportable
  extend ActiveSupport::Concern

  included do
    has_logidze
  end

  def static_data_version
    id = log_data.responsible_id
    StaticDataVersion.find(id) if id.present?
  end
end
