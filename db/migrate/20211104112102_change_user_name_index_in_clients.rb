# frozen_string_literal: true

class ChangeUserNameIndexInClients < ActiveRecord::Migration[6.1]
  def change
    remove_index(:clients, :email)
    add_index(:clients, :email, unique: false)
  end
end
