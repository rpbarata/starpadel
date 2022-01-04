# frozen_string_literal: true

module Clients
  class LessonsController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Aulas Creditadas", href: clients_credited_lessons_path },
        { text: "Agendamento de Aulas", href: clients_credited_lesson_lessons_path },
      ]

      @credited_lesson = current_client.credited_lessons.find(params[:credited_lesson_id])
      @lessons = @credited_lesson.client_lessons
    end
  end
end
