# frozen_string_literal: true

class AddPaymentToClientLessonsGroup < ActiveRecord::Migration[6.1]
  def change
    add_column(:client_lessons_groups, :payment, :decimal, precision: 8, scale: 2, default: 0.0)
    add_column(:client_lessons_groups, :lesson_price, :decimal, precision: 8, scale: 2, default: 0.0)
  end
end
