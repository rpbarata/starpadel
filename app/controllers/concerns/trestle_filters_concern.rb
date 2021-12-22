# frozen_string_literal: true

module TrestleFiltersConcern
  extend ActiveSupport::Concern

  def initialize_credited_lessons_filters
    @credited_lessons = @collection if @collection.present?

    @filter_dropdown_lists = [
      { name: "lesson_type", label: "Tipo de Aulas",
        options: LessonsType.actives.order(name: :asc).pluck(:name, :id).unshift(["Todas", nil]),
        query_param: "lessons_type_id", },
    ]

    begin
      if instance&.present?
        filter = @filter_dropdown_lists.select { |f| f[:name] == instance.class.model_name.singular }

        if filter.present?
          filter.first[:options] = [[instance.name, instance.id]]
        end
      end
    rescue StandardError => _e
      # do nothing
    end

    @filter_dropdown_lists.each do |filter|
      if params[filter[:name]].present? && filter[:query_param].present?
        @credited_lessons = @credited_lessons.where(filter[:query_param] => params[filter[:name]])
      end
    end

    @filter_dropdown_lists << {
      name: "status", label: "Estado do Pagamento",
      options: [["Todas", nil], ["Pago", "paid"], ["Por Pagar", "unpaid"]],
      query_param: "status",
    }

    if params[:status].present?
      case params[:status]
      when "paid"
        @credited_lessons = @credited_lessons.paid
      when "unpaid"
        @credited_lessons = @credited_lessons.unpaid
      end
    end

    @filter_dates = true

    if params[:start_date].present? && params[:end_date].present?
      @credited_lessons =
        @credited_lessons.where(
          "credited_lessons.created_at BETWEEN :start_date AND :end_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day,
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    elsif params[:start_date].present?
      @credited_lessons =
        @credited_lessons.where(
          "credited_lessons.created_at >= :start_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day
        )
    elsif params[:end_date].present?
      @credited_lessons =
        @credited_lessons.where(
          "credited_lessons.created_at <= :end_date",
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    end

    @collection = @credited_lessons
  end

  def initialize_client_lessons_filters
    @client_lessons = @collection if @collection.present?

    @filter_dropdown_lists = [
      { name: "client", label: "Cliente",
        options: Client.all.order(name: :asc).pluck(:name, :id).unshift(["Todos", nil]),
        query_param: "client_id", },
    ]

    @filter_dropdown_lists << {
      name: "coach", label: "Treinador", options: Admin.coach_admin.pluck(:username, :id).unshift(["Todos", nil]),
      query_param: "coach_admin_id",
    } unless current_user.coach_admin?

    begin
      if instance&.present?
        filter = @filter_dropdown_lists.select { |f| f[:name] == instance.class.model_name.singular }

        if filter.present?
          filter.first[:options] = [[instance.name, instance.id]]
        end
      end
    rescue StandardError => _e
      # do nothing
    end

    @filter_dropdown_lists.each do |filter|
      if params[filter[:name]].present? && filter[:query_param].present?
        @client_lessons = @client_lessons.where(filter[:query_param] => params[filter[:name]])
      end
    end

    @filter_dates = true

    if params[:start_date].present? && params[:end_date].present?
      @client_lessons =
        @client_lessons.where(
          "client_lessons.start_time >= :start_date AND client_lessons.end_time <= :end_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day,
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    elsif params[:start_date].present?
      @client_lessons =
        @client_lessons.where(
          "client_lessons.start_time >= :start_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day
        )
    elsif params[:end_date].present?
      @client_lessons =
        @client_lessons.where(
          "client_lessons.end_time <= :end_date",
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    end

    @collection = @client_lessons
  end
end
