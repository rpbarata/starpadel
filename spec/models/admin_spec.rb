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

  it "is valid with the respective data" do
    expect(build(:admin)).to be_valid
  end

  it "is invalid without username" do
    expect(build(:admin, username: nil)).not_to be_valid
  end

  it "is invalid without an unique username" do
    second_admin = Admin.create(username: "username", password_digest: "123456")
    expect(build(:admin, username: second_admin.username)).not_to be_valid
  end
end
