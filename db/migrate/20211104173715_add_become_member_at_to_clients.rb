# frozen_string_literal: true

class AddBecomeMemberAtToClients < ActiveRecord::Migration[6.1]
  def change
    add_column(:clients, :become_member_at, :datetime)

    # Client.connection.schema_cache.clear!
    # Client.reset_column_information

    # reversible do |dir|
    #   dir.up do
    #     Client.members_of_club.update_all(become_member_at: Time.current) # rubocop:disable Rails/SkipsModelValidations
    #   end
    # end
  end
end
