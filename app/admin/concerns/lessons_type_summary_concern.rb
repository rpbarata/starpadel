# frozen_string_literal: true

module LessonsTypeSummaryConcern
  extend ActiveSupport::Concern

  def lessons_type_summary
    @lessons_type_summary = LessonsType.all.order(name: :asc).map do |lesson_type|
      {
        lesson_type_name: lesson_type.name,
        green_time: @client_lessons_groups.where(lessons_type: lesson_type, time_period: :green_time).size,
        red_time: @client_lessons_groups.where(lessons_type: lesson_type, time_period: :red_time).size,
        total: @client_lessons_groups.where(lessons_type: lesson_type).size,
      }
    end
  end
end
