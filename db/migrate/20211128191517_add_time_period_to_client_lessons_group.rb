# frozen_string_literal: true

class AddTimePeriodToClientLessonsGroup < ActiveRecord::Migration[6.1]
  def change
    add_column(:client_lessons_groups, :time_period, :integer)
  end
end
