# frozen_string_literal: true

class AddIsActiveToLessonsType < ActiveRecord::Migration[6.1]
  def change
    add_column(:lessons_types, :is_active, :boolean, default: true)
  end
end
