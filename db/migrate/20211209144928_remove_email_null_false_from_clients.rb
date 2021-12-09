# frozen_string_literal: true

class RemoveEmailNullFalseFromClients < ActiveRecord::Migration[6.1]
  def change
    change_column(:clients, :email, :string, null: true, default: "")
  end
end
