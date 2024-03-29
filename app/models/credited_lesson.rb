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
#  index_credited_lessons_on_client_id                 (client_id)
#  index_credited_lessons_on_created_at                (created_at)
#  index_credited_lessons_on_lesson_price              (lesson_price)
#  index_credited_lessons_on_lesson_price_and_payment  (lesson_price,payment)
#  index_credited_lessons_on_lessons_type_id           (lessons_type_id)
#  index_credited_lessons_on_payment                   (payment)
#  index_credited_lessons_on_time_period               (time_period)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
class CreditedLesson < ApplicationRecord
  # has_paper_trail

  attr_accessor :new_payment, :voucher_id

  scope :paid, -> { where("payment = lesson_price") }
  scope :unpaid, -> { where("payment < lesson_price") }

  belongs_to :lessons_type
  belongs_to :client
  has_many :client_lessons, dependent: :restrict_with_error
  has_many :movements, dependent: :destroy

  enum time_period: { green_time: 1, red_time: 2 }

  after_create :generate_client_lessons
  after_create :set_lesson_price

  validates :time_period, presence: true
  validate :validate_new_payment

  class << self
    def select_by_date(start_date, end_date)
      if start_date.present? && end_date.present?
        where("credited_lessons.created_at BETWEEN :start_date AND :end_date",
          start_date: start_date.beginning_of_day, end_date: end_date.end_of_day).distinct
      elsif start_date.present?
        where("credited_lessons.created_at > :start_date", start_date: start_date.beginning_of_day).distinct
      elsif end_date.present?
        where("credited_lessons.created_at < :end_date", end_date: end_date.end_of_day).distinct
      else
        where("credited_lessons.created_at BETWEEN :start_date AND :end_date",
          start_date: (Time.zone.now.beginning_of_day - 31.days), end_date: Time.zone.now.end_of_day).distinct
      end
    end

    def get(client_id = nil)
      if client_id.present?
        where(client_id: client_id)
      else
        all
      end
    end
  end

  def remaining_lessons_str
    "#{client_lessons.done.size} de #{lessons_type.number_of_lessons}"
  end

  def payment_left_str
    "#{ActionController::Base.helpers.number_to_currency(payment,
      unit: "€")} de #{ActionController::Base.helpers.number_to_currency(lesson_price, unit: "€")}"
  end

  def add_payment(new_payment)
    self.payment += new_payment
  end

  def create_movement(voucher_id, value)
    movement = Movement.new(
      from_credited_lesson: true,
      value: value,
      credited_lesson_id: id,
      voucher_id: voucher_id,
      client_id: client.id
    )

    movement.save
  end

  def paid?
    payment == lesson_price
  end

  def formated_str
    "#{client.name} - #{lessons_type.name} (#{payment_left_str})"
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

  def set_lesson_price
    self.lesson_price =
      if client.member_id.present?
        if green_time?
          lessons_type.green_time_member_price
        else
          lessons_type.red_time_member_price
        end
      elsif green_time?
        lessons_type.green_time_not_member_price
      else
        lessons_type.red_time_not_member_price
      end

    save!
  end

  def validate_new_payment
    if payment > lesson_price
      errors.add(:new_payment, "não pode exceder o valor em dívida")
    end
  end
end
