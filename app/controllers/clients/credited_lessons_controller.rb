# frozen_string_literal: true

module Clients
  class CreditedLessonsController < ClientController
    def index
      @breadcrumbs = [
        { text: "Home", href: root_path },
        { text: "Aulas", href: clients_credited_lessons_path },
      ]

      @credited_lessons =
        current_client.credited_lessons.includes([:lessons_type]).order(created_at: :desc).page(params[:page])

      index_apply_filters
      index_set_filter_array
    end

    private

    def index_set_filter_array
      @filters_drop_down_array = [
        { name: "lesson_type_id", label: "Tipo de Aula",
          options: LessonsType.where(id: current_client.credited_lessons.pluck(:lessons_type_id)).order(name: :asc)
            .pluck(:name, :id).unshift(["Todas", nil]), },
        { name: "status", label: "Estado Pagamento",
          options: [["Todas", nil], ["Pago", "paid"], ["Por Pagar", "unpaid"]], },
        { name: "time_period", label: "Horário",
          options: [["Todos", nil], ["Green Time", "green_time"], ["Red Time", "red_time"]], },
      ]
    end

    def index_apply_filters
      if params[:lesson_type_id].present?
        @credited_lessons = @credited_lessons.where(lessons_type_id: params[:lesson_type_id])
      end

      if params[:status].present?
        case params[:status]
        when "paid"
          @credited_lessons = @credited_lessons.paid
        when "unpaid"
          @credited_lessons = @credited_lessons.unpaid
        end
      end

      if params[:time_period].present?
        @credited_lessons = @credited_lessons.where(time_period: params[:time_period])
      end
    end
  end
end
