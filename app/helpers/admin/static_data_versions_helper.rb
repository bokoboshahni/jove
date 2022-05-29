# frozen_string_literal: true

module Admin
  module StaticDataVersionsHelper
    STATIC_DATA_VERSION_STATUS_COLORS = {
      pending: :secondary,
      downloading: :notice,
      importing: :notice,
      downloaded: :tertiary,
      imported: :success,
      downloading_failed: :danger,
      importing_failed: :danger
    }.freeze

    def static_data_version_status_color(version)
      STATIC_DATA_VERSION_STATUS_COLORS.fetch(version.status.to_sym)
    end
  end
end
