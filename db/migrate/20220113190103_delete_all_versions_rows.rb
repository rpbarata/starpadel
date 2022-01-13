# frozen_string_literal: true

class DeleteAllVersionsRows < ActiveRecord::Migration[6.1]
  def up
    drop_table(:versions)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
