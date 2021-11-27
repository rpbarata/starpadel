# frozen_string_literal: true

class CreateClientLessonsGroups < ActiveRecord::Migration[6.1]
  def change
    create_table(:client_lessons_groups) do |t|
      t.references(:client, null: false, foreign_key: true)
      t.references(:lessons_type, null: false, foreign_key: true)
      t.text(:comments)

      t.timestamps
    end
  end
end
