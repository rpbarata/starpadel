# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@starpadel.pt"
  layout "mailer"
end
