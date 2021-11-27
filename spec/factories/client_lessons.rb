# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons
#
#  id              :bigint           not null, primary key
#  comments        :text
#  end_time        :datetime
#  lesson_group    :integer
#  start_time      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#  lessons_type_id :bigint           not null
#
# Indexes
#
#  index_client_lessons_on_client_id        (client_id)
#  index_client_lessons_on_lessons_type_id  (lessons_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
FactoryBot.define do
  factory :client_lesson do
    start_time { "2021-11-26 22:20:26" }
    end_time { "2021-11-26 22:20:26" }
    client { nil }
    lessons_type { nil }
    comments { "MyText" }
  end
end
