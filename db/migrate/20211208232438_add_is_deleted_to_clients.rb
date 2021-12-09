# frozen_string_literal: true

class AddIsDeletedToClients < ActiveRecord::Migration[6.1]
  def change
    add_column(:clients, :is_deleted, :boolean, default: false)
  end
end
