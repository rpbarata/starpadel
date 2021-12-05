# frozen_string_literal: true

# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  code       :string
#  comments   :text
#  validity   :datetime
#  value      :decimal(8, 2)    default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_vouchers_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :voucher do
    client { nil }
    value { "9.99" }
    comments { "MyText" }
    code { "MyString" }
    validity { "2021-12-04 22:20:05" }
  end
end
