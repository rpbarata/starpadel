# frozen_string_literal: true

class AddIsMasterMemberToClients < ActiveRecord::Migration[6.1]
  def change
    add_column(:clients, :is_master_member, :boolean, default: false)
  end
end
