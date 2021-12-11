# frozen_string_literal: true

class DeleteAdminsTable < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        drop_table(:admins)
      end

      dir.down do |dir|
      end
    end
  end
end
