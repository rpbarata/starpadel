# frozen_string_literal: true

module Clients
  class CreditedLessonsController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Aulas", href: clients_credited_lessons_path },
      ]

      @credited_lessons = current_client.credited_lessons.includes([:lessons_type]).order(created_at: :desc).page(params[:page])
    end
  end
end
