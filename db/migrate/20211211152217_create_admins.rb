# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table(:admins) do |t|
      t.string(:email)
      t.string(:password_digest)
      t.string(:remember_token)
      t.datetime(:remember_token_expires_at)
      t.string(:username)
      t.integer(:role)

      t.timestamps
    end

    add_index(:admins, :username, unique: true)
  end
end
