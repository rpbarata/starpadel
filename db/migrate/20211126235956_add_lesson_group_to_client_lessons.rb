# frozen_string_literal: true

class AddLessonGroupToClientLessons < ActiveRecord::Migration[6.1]
  def change
    add_column(:client_lessons, :lesson_group, :integer)
  end
end
