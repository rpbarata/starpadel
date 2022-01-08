# frozen_string_literal: true

module Clients
  class LessonsController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Aulas", href: clients_credited_lessons_path },
        { text: "Agendamento", href: clients_credited_lesson_lessons_path },
      ]

      @credited_lesson = current_client.credited_lessons.find(params[:credited_lesson_id])
      @lessons = @credited_lesson.client_lessons.includes([:coach_admin]).order(created_at: :desc)
    end
  end
end
