# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  address                :string
#  avatar_last_update     :datetime
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
require "rails_helper"

RSpec.describe(Client, type: :model) do
  
  it "is valid with the respective data" do
    expect(build(:client)).to be_valid
  end

  it "is invalid without a name" do 
    expect(build(:client, name: nil)).not_to be_valid
  end

  it "is invalid with a NIF bigger than 9 characters" do
    expect(build(:client, nif: "0123456789")).not_to be_valid
  end

  it "is invalid with a NIF smaller than 9 characters" do
    expect(build(:client, nif: "123")).not_to be_valid
  end

  it "is invalid with a NIF that it is not a number" do
    expect(build(:client, nif: "abc")).not_to be_valid
  end

  it "is invalid with a NIF smaller than 0" do
    expect(build(:client, nif: "-12345678")).not_to be_valid
  end

  it "is invalid without a unique NIF" do
    client1 = build(:client)
    client2 = build(:client)
    expect(client2).not_to be_valid
  end

end
