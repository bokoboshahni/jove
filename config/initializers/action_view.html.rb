# frozen_string_literal: true

Rails.application.config.action_view.field_error_proc = ->(html_tag, _instance) { html_tag }
