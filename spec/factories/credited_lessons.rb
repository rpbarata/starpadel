# frozen_string_literal: true

# == Schema Information
#
# Table name: credited_lessons
#
#  id              :bigint           not null, primary key
#  comments        :text
#  lesson_price    :decimal(8, 2)    default(0.0)
#  payment         :decimal(8, 2)    default(0.0)
#  time_period     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#  lessons_type_id :bigint           not null
#
# Indexes
#
#  index_credited_lessons_on_client_id        (client_id)
#  index_credited_lessons_on_created_at       (created_at)
#  index_credited_lessons_on_lessons_type_id  (lessons_type_id)
#  index_credited_lessons_on_time_period      (time_period)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
FactoryBot.define do
  factory :credited_lesson do
  end
end
