# frozen_string_literal: true

class CreateVouchers < ActiveRecord::Migration[6.1]
  def change
    create_table(:vouchers) do |t|
      t.references(:client, null: false, foreign_key: true)
      t.decimal(:value, precision: 8, scale: 2, default: 0.0)
      t.text(:comments)
      t.string(:code)
      t.datetime(:validity)

      t.timestamps
    end
  end
end
