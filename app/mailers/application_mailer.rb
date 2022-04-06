# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Jove.config.email_from
  layout 'mailer'
end
