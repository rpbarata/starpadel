# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id                        :bigint           not null, primary key
#  email                     :string
#  password_digest           :string
#  remember_token            :string
#  remember_token_expires_at :datetime
#  role                      :integer
#  username                  :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_admins_on_username  (username) UNIQUE
#
require "rails_helper"

RSpec.describe(Admin, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
