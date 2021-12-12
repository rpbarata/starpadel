# frozen_string_literal: true
class SentryJob < ApplicationJob
  queue_as :default

  def perform(exception, params = {}, level = "error")
    Sentry.capture_exception(exception, level: level, extra: params)
  end
end
