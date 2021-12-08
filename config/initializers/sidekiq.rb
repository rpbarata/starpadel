# frozen_string_literal: true

require "sidekiq"
require "sidekiq/web"
require "sidekiq-scheduler/web"

Sidekiq.configure_server do |config|
  config.redis = {
    host: ENV.fetch("REDIS_HOST", "redis"),
    port: ENV.fetch("REDIS_PORT", 6379),
    username: ENV.fetch("REDIS_USERNAME", nil),
    password: ENV.fetch("REDIS_PASSWORD", nil),
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: ENV.fetch("REDIS_HOST", "redis"),
    port: ENV.fetch("REDIS_PORT", 6379),
    username: ENV.fetch("REDIS_USERNAME", nil),
    password: ENV.fetch("REDIS_PASSWORD", nil),
  }
end
