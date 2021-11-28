# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons_groups
#
#  id              :bigint           not null, primary key
#  comments        :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#  lessons_type_id :bigint           not null
#
# Indexes
#
#  index_client_lessons_groups_on_client_id        (client_id)
#  index_client_lessons_groups_on_lessons_type_id  (lessons_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
class ClientLessonsGroup < ApplicationRecord
  belongs_to :lessons_type
  belongs_to :client
  has_many :client_lessons, dependent: :restrict_with_error

  after_create :generate_client_lessons

  class << self
    def select_by_date(start_date, end_date)
      if start_date.present? && end_date.present?
        where("client_lessons_groups.created_at BETWEEN :start_date AND :end_date",
          start_date: start_date.beginning_of_day, end_date: end_date.end_of_day).distinct
      elsif start_date.present?
        where("client_lessons_groups.created_at > :start_date", start_date: start_date.beginning_of_day).distinct
      elsif end_date.present?
        where("client_lessons_groups.created_at < :end_date", end_date: end_date.end_of_day).distinct
      else
        where("client_lessons_groups.created_at BETWEEN :start_date AND :end_date",
          start_date: (Time.zone.now.beginning_of_day - 31.days), end_date: Time.zone.now.end_of_day).distinct
      end
    end
  end

  private

  def generate_client_lessons
    ActiveRecord::Base.transaction do
      lessons_type = LessonsType.find(lessons_type_id)
      lessons_type.number_of_lessons.times do |_i|
        client_lessons.create(client_id: client_id, lessons_type_id: lessons_type_id)
      end
    end
  end
end
