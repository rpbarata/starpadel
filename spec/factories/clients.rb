# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  address                :string
#  become_member_at       :datetime
#  birth_date             :date
#  comments               :text
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  identification_number  :string
#  is_deleted             :boolean          default(FALSE)
#  is_master_member       :boolean          default(FALSE)
#  name                   :string
#  nif                    :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rfid_number            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fpp_id                 :integer
#  member_id              :integer
#
# Indexes
#
#  index_clients_on_birth_date            (birth_date)
#  index_clients_on_created_at            (created_at)
#  index_clients_on_email                 (email)
#  index_clients_on_is_master_member      (is_master_member)
#  index_clients_on_member_id             (member_id)
#  index_clients_on_name                  (name)
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :client do
  end
end
