# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons_types
#
#  id                          :bigint           not null, primary key
#  comments                    :text
#  green_time_member_price     :decimal(8, 2)
#  green_time_not_member_price :decimal(8, 2)
#  is_active                   :boolean          default(TRUE)
#  is_pack                     :boolean
#  name                        :string
#  number_of_lessons           :integer
#  red_time_member_price       :decimal(8, 2)
#  red_time_not_member_price   :decimal(8, 2)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_lessons_types_on_is_active  (is_active)
#  index_lessons_types_on_is_pack    (is_pack)
#  index_lessons_types_on_name       (name) UNIQUE
#
FactoryBot.define do
  factory :lessons_type do
    name { "MyString" }
    comments { "MyText" }
    green_time_member_price { "9.99" }
    green_time_not_member_price { "9.99" }
    red_time_member_price { "9.99" }
    red_time_not_member_price { "9.99" }
    is_pack { false }
    number_of_lessons { 1 }
  end
end
