# frozen_string_literal: true

class AddClientLessonsGroupToClientLessons < ActiveRecord::Migration[6.1]
  def change
    # rubocop:disable Rails/NotNullColumn
    add_reference(:client_lessons, :client_lessons_group, null: false, foreign_key: true)
    # rubocop:enable Rails/NotNullColumn
    remove_column(:client_lessons, :lesson_group, :integer)
  end
end
