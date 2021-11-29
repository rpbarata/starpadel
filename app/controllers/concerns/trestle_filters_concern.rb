# frozen_string_literal: true

module TrestleFiltersConcern
  extend ActiveSupport::Concern

  def initialize_client_lessons_groups_filters
    @filter_dropdown_lists = [
      { name: "lesson_type", label: "Tipo de Aulas",
        options: LessonsType.actives.order(name: :asc).pluck(:name, :id).unshift(["Todos", nil]),
        query_param: "lessons_type_id", },
    ]

    @filter_dropdown_lists.each do |filter|
      if params[filter[:name]].present? && filter[:query_param].present?
        @collection = @collection.where(filter[:query_param] => params[filter[:name]])
      end
    end

    @filter_dates = true

    if params[:start_date].present? && params[:end_date].present?
      @collection =
        @collection.where(
          "client_lessons_groups.created_at BETWEEN :start_date AND :end_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day,
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    elsif params[:start_date].present?
      @collection =
        @collection.where(
          "client_lessons_groups.created_at >= :start_date",
          start_date: params[:start_date].in_time_zone.beginning_of_day
        )
    elsif params[:end_date].present?
      @collection =
        @collection.where(
          "client_lessons_groups.created_at <= :end_date",
          end_date: params[:end_date].in_time_zone.end_of_day
        )
    end
  end
end
