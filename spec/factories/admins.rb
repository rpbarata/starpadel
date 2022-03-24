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
FactoryBot.define do
  factory :admin do
    email { Faker::Internet.unique.email }
    password_digest { "MyString" }
    username { Faker::Name.unique.name }
    remember_token { "MyString" }
    remember_token_expires_at { "2021-12-11 15:22:17" }
    role { :super_admin }
  end
end
