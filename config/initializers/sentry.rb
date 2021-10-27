# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.environment = ENV["SENTRY_ENV"]
  config.traces_sample_rate = 0.5
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
end
