# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  address                :string
#  become_member_at       :datetime
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
#  index_clients_on_email                 (email)
#  index_clients_on_name                  (name)
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :client do
  end
end
