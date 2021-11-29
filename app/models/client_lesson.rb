# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons
#
#  id                      :bigint           not null, primary key
#  comments                :text
#  end_time                :datetime
#  start_time              :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  client_id               :bigint           not null
#  client_lessons_group_id :bigint           not null
#  lessons_type_id         :bigint           not null
#
# Indexes
#
#  index_client_lessons_on_client_id                (client_id)
#  index_client_lessons_on_client_lessons_group_id  (client_lessons_group_id)
#  index_client_lessons_on_lessons_type_id          (lessons_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (client_lessons_group_id => client_lessons_groups.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
class ClientLesson < ApplicationRecord
  belongs_to :client_lessons_group, dependent: :destroy
  belongs_to :lessons_type
  belongs_to :client, dependent: :destroy

  validate :validate_dates

  scope :done, -> { where.not(start_time: nil, end_time: nil) }

  private

  def validate_dates
    if start_time.blank? && end_time.present?
      errors.add(:start_time, "não pode estar em branco")
      errors.add(:end_time, "")
    elsif start_time > end_time
      errors.add(:start_time, "deve ser antes da data de fim")
      errors.add(:end_time, "deve ser depois da data de início")
    end
  end
end
