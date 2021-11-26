# frozen_string_literal: true

class CreateLessonsTypes < ActiveRecord::Migration[6.1]
  def change
    create_table(:lessons_types) do |t|
      t.string(:name)
      t.text(:comments)
      t.decimal(:green_time_member_price, precision: 8, scale: 2)
      t.decimal(:green_time_not_member_price, precision: 8, scale: 2)
      t.decimal(:red_time_member_price, precision: 8, scale: 2)
      t.decimal(:red_time_not_member_price, precision: 8, scale: 2)
      t.boolean(:is_pack)
      t.integer(:number_of_lessons)

      t.timestamps
    end
  end
end
