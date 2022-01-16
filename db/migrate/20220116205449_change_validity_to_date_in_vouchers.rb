class ChangeValidityToDateInVouchers < ActiveRecord::Migration[6.1]
  def change
    change_column :vouchers, :validity, :date
  end
end
