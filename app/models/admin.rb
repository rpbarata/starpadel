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
class Admin < ApplicationRecord
  include Trestle::Auth::ModelMethods
  include Trestle::Auth::ModelMethods::Rememberable

  enum role: { super_admin: 1, coach_admin: 2, secretariat_admin: 3 }
  validates :username, presence: true, uniqueness: true

  has_many :client_lessons, dependent: :restrict_with_error
end
