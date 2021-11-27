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
class ClientLesson < ApplicationRecord
  belongs_to :client
  belongs_to :lessons_type

  validate :validate_dates, if: -> { start_time.present? && end_time.present? }

  class << self
    def generate(client_id, lessons_type_id, comments)
      success = false
      lesson_group = ClientLesson.all.order(lesson_group: :desc).first&.lesson_group
      lesson_group = lesson_group.present? ? (lesson_group + 1) : 1
      ActiveRecord::Base.transaction do
        lessons_type = LessonsType.find(lessons_type_id)
        lessons_type.number_of_lessons.times do |_i|
          success = ClientLesson.create(client_id: client_id, lessons_type_id: lessons_type_id, comments: comments,
            lesson_group: lesson_group)
        end
      end
      success
    end
  end

  private

  def validate_dates
    if start_time > end_time
      errors.add(:start_time, "a data de inicio deve ser antes da data de fim")
      errors.add(:end_time, "a data de inicio deve ser antes da data de fim")
    end
  end
end
