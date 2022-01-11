# frozen_string_literal: true

module Clients
  class CalendarController < ClientController
    def index
      # https://fullcalendar.io/docs/event-object
      @events = ClientLesson.done.where(client_id: current_client.id)
    end
  end
end
