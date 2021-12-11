class AthleteController < ApplicationController
  before_action :authenticate_client!

  def index
    @credited_lessons = current_client.credited_lessons
    @vouchers = current_client.vouchers
  end
end
