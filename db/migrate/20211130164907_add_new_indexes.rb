# frozen_string_literal: true

class AddNewIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index(:client_lessons, :end_time)
    add_index(:client_lessons, :start_time)
    add_index(:client_lessons, [:start_time, :end_time])
    add_index(:client_lessons, :created_at)

    add_index(:client_lessons_groups, :created_at)
    add_index(:client_lessons_groups, :time_period)

    add_index(:lessons_types, :name)
    add_index(:lessons_types, :is_pack)
    add_index(:lessons_types, :is_active)
  end
end
