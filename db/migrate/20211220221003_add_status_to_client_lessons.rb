class AddStatusToClientLessons < ActiveRecord::Migration[6.1]
  def change
    add_column :client_lessons, :status, :integer
  end
end
