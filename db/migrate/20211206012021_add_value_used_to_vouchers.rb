# frozen_string_literal: true

class AddValueUsedToVouchers < ActiveRecord::Migration[6.1]
  def change
    add_column(:vouchers, :value_used, :decimal, default: 0)
  end
end
