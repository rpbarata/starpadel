# frozen_string_literal: true

class HealthJob < ApplicationJob
  queue_as :default

  def perform
    raise "Health Test FAILED" if request != "OK"
  rescue => exception
    SentryJob.perform_now(exception, { source: "HealthJob", res: request })
    nil
  end

  private

  def request
    uri = URI("#{ENV["HOST"]}/health")

    Net::HTTP.get(uri)
  end
end
