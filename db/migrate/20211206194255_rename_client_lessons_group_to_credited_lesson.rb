# frozen_string_literal: true

class RenameClientLessonsGroupToCreditedLesson < ActiveRecord::Migration[6.1]
  def change
    rename_table(:client_lessons_groups, :credited_lessons)

    rename_column(:client_lessons, :client_lessons_group_id, :credited_lesson_id)
    rename_column(:movements, :client_lessons_group_id, :credited_lesson_id)
    rename_column(:movements, :from_client_lessons_group, :from_credited_lesson)
  end
end
