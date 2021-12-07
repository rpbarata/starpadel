# frozen_string_literal: true

class CreateNewIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index(:credited_lessons, :lesson_price)
    add_index(:credited_lessons, :payment)
    add_index(:credited_lessons, [:lesson_price, :payment])

    add_index(:movements, :date)

    add_index(:vouchers, :code, unique: true)
    add_index(:vouchers, :validity)
    add_index(:vouchers, :value)
    add_index(:vouchers, :value_used)
    add_index(:vouchers, [:value, :value_used])

    remove_index(:lessons_types, :name)
    add_index(:lessons_types, :name, unique: true)
  end
end
