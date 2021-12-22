# frozen_string_literal: true

class AddActiveToClients < ActiveRecord::Migration[6.1]
  def change
    add_column(:clients, :active, :boolean, default: false)
  end
end
