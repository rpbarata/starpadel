class SanityTestJob < ApplicationJob
  queue_as :default

  def perform
    STDOUT.puts("############ SanityTestJob says hello! ############")
  end
end