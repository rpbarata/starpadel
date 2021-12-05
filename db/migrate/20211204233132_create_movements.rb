# frozen_string_literal: true

class CreateMovements < ActiveRecord::Migration[6.1]
  def change
    create_table(:movements) do |t|
      t.references(:voucher, null: false, foreign_key: true)
      t.datetime(:date)
      t.decimal(:value, precision: 8, scale: 2, default: 0.0)
      t.string(:description)
      t.text(:comments)
      t.references(:client_lessons_group, null: true, foreign_key: true)
      t.boolean(:from_client_lessons_group)
      t.references(:client, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
