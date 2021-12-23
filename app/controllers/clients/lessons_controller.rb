# frozen_string_literal: true

module Clients
  class LessonsController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Aulas Creditadas", :clients_credited_lessons_path
    add_breadcrumb "Agendamento de Aulas", :clients_credited_lesson_lessons_path

    before_action :authenticate_client!

    def index
      @credited_lesson = current_client.credited_lessons.find(params[:credited_lesson_id])
      @lessons = @credited_lesson.client_lessons
    end
  end
end
