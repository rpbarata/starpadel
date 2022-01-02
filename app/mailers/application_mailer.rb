# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILJET_DEFAULT_FROM")
  layout "mailer"
end
