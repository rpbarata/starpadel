# frozen_string_literal: true

module Clients
  class CreditedLessonsController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Aulas Creditadas", :clients_credited_lessons_path

    before_action :authenticate_client!

    def index
      @credited_lessons = current_client.credited_lessons.includes([:lessons_type])
    end
  end
end
