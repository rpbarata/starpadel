# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  address                :string
#  birth_date             :date
#  comments               :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  identification_number  :string
#  name                   :string
#  nif                    :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rfid_number            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fpp_id                 :string
#  member_id              :string
#
# Indexes
#
#  index_clients_on_email                 (email) UNIQUE
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  scope :members_of_club, -> { where.not(member_id: [nil, ""])}
  scope :not_members_of_club, -> { where(member_id: [nil, ""])}

end
