class HealthJob < ApplicationJob
  queue_as :default

  def perform
    begin
      raise "Health Test FAILED" if request != "OK"
    rescue => exception
      SentryJob.perform_now(exception, { source: "HealthJob", res: request })
      return
    end
  end

  private

  def request
    uri = URI("#{ENV["HOST"]}/health")

    Net::HTTP.get(uri)
  end
end