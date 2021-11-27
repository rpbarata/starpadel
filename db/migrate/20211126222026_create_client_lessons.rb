# frozen_string_literal: true

class CreateClientLessons < ActiveRecord::Migration[6.1]
  def change
    create_table(:client_lessons) do |t|
      t.datetime(:start_time)
      t.datetime(:end_time)
      t.references(:client, null: false, foreign_key: true)
      t.references(:lessons_type, null: false, foreign_key: true)
      t.text(:comments)

      t.timestamps
    end
  end
end
