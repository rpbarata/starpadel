class AddClientLessonsCountToCreditedLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :credited_lessons, :client_lessons_count, :integer

    CreditedLesson.connection.schema_cache.clear!
    CreditedLesson.reset_column_information

    reversible do |dir|
      dir.up do
        CreditedLesson.find_each do |credited_lesson|
          CreditedLesson.reset_counters(credited_lesson.id, :client_lessons)
        end
      end
    end
  end
end
