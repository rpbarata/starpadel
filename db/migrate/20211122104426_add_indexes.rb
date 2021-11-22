# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index(:admins, :role)
    add_index(:admins, :email)
    add_index(:admins, [:username, :email])

    add_index(:clients, :member_id)
    add_index(:clients, :is_master_member)
    add_index(:clients, :birth_date)
    add_index(:clients, :created_at)
  end
end
