# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    has_logidze
  end

  def last_modified_by
    return unless last_modified_by_id.present?

    Identity.find(last_modified_by_id)
  end

  def last_modified_by_id
    log_data.responsible_id
  end
end
