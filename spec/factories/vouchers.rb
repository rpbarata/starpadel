# frozen_string_literal: true

# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  code       :string
#  comments   :text
#  validity   :date
#  value      :decimal(8, 2)    default(0.0)
#  value_used :decimal(, )      default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_vouchers_on_client_id             (client_id)
#  index_vouchers_on_code                  (code) UNIQUE
#  index_vouchers_on_validity              (validity)
#  index_vouchers_on_value                 (value)
#  index_vouchers_on_value_and_value_used  (value,value_used)
#  index_vouchers_on_value_used            (value_used)
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
