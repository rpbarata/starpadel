# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons
#
#  id                 :bigint           not null, primary key
#  comments           :text
#  end_time           :datetime
#  start_time         :datetime
#  status             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  client_id          :bigint           not null
#  coach_admin_id     :bigint
#  credited_lesson_id :bigint           not null
#  lessons_type_id    :bigint           not null
#
# Indexes
#
#  index_client_lessons_on_client_id                (client_id)
#  index_client_lessons_on_created_at               (created_at)
#  index_client_lessons_on_credited_lesson_id       (credited_lesson_id)
#  index_client_lessons_on_end_time                 (end_time)
#  index_client_lessons_on_lessons_type_id          (lessons_type_id)
#  index_client_lessons_on_start_time               (start_time)
#  index_client_lessons_on_start_time_and_end_time  (start_time,end_time)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (credited_lesson_id => credited_lessons.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
class ClientLesson < ApplicationRecord
  attr_accessor :tmp_original_client_id
  attr_accessor :tmp_team_ids
  has_paper_trail

  belongs_to :credited_lesson, dependent: :destroy, counter_cache: :client_lessons_count
  belongs_to :lessons_type
  belongs_to :coach_admin, class_name: "Admin", optional: true

  has_and_belongs_to_many :clients

  validate :validate_dates, if: -> { start_time.present? || end_time.present? }

  scope :done, -> { where.not(start_time: nil, end_time: nil) }

  private

  def validate_dates
    if start_time.blank? && end_time.present?
      errors.add(:start_time, "não pode estar em branco")
      errors.add(:end_time, "")
    elsif (start_time.present? && end_time.present?) && (start_time > end_time)
      errors.add(:start_time, "deve ser antes da data de fim")
      errors.add(:end_time, "deve ser depois da data de início")
    end
  end
end
