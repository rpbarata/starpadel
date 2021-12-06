# frozen_string_literal: true

class ChangeClientMembersType < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def up
    change_column(:clients, :member_id, :integer, using: "member_id::integer")
    change_column(:clients, :fpp_id, :integer, using: "fpp_id::integer")
  end
  # rubocop:enable Rails/BulkChangeTable

  # rubocop:disable Rails/BulkChangeTable
  def down
    change_table(:clients) do |t|
      t.change(:member_id, :string)
      t.change(:fpp_id, :string)
    end
  end
  # rubocop:enable Rails/BulkChangeTable
end
