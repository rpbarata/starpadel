# frozen_string_literal: true

# == Schema Information
#
# Table name: movements
#
#  id                        :bigint           not null, primary key
#  comments                  :text
#  date                      :datetime
#  description               :string
#  from_client_lessons_group :boolean
#  value                     :decimal(8, 2)    default(0.0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  client_id                 :bigint           not null
#  client_lessons_group_id   :bigint
#  voucher_id                :bigint           not null
#
# Indexes
#
#  index_movements_on_client_id                (client_id)
#  index_movements_on_client_lessons_group_id  (client_lessons_group_id)
#  index_movements_on_voucher_id               (voucher_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (client_lessons_group_id => client_lessons_groups.id)
#  fk_rails_...  (voucher_id => vouchers.id)
#
FactoryBot.define do
  factory :movement do
    voucher { nil }
    date { "2021-12-04 23:31:32" }
    value { "9.99" }
    description { "MyString" }
    comments { "MyText" }
    lesson_group { nil }
  end
end
