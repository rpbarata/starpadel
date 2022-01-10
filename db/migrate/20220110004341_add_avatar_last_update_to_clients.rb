# frozen_string_literal: true

class AddAvatarLastUpdateToClients < ActiveRecord::Migration[6.1]
  def change
    add_column(:clients, :avatar_last_update, :datetime)
  end
end
