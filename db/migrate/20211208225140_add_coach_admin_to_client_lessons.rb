# frozen_string_literal: true

class AddCoachAdminToClientLessons < ActiveRecord::Migration[6.1]
  def change
    add_column(:client_lessons, :coach_admin_id, :bigint, null: true, foreign_key: true)
  end
end
