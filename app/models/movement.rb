# frozen_string_literal: true

# == Schema Information
#
# Table name: movements
#
#  id                   :bigint           not null, primary key
#  comments             :text
#  date                 :datetime
#  description          :string
#  from_credited_lesson :boolean
#  value                :decimal(8, 2)    default(0.0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  client_id            :bigint           not null
#  credited_lesson_id   :bigint
#  voucher_id           :bigint           not null
#
# Indexes
#
#  index_movements_on_client_id           (client_id)
#  index_movements_on_credited_lesson_id  (credited_lesson_id)
#  index_movements_on_date                (date)
#  index_movements_on_voucher_id          (voucher_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (credited_lesson_id => credited_lessons.id)
#  fk_rails_...  (voucher_id => vouchers.id)
#
class Movement < ApplicationRecord
  has_paper_trail

  belongs_to :voucher
  belongs_to :credited_lesson, optional: true
  belongs_to :client

  validates :description, presence: true, if: -> { !from_credited_lesson }
  validates :value, numericality: { greater_than: 0 }, presence: true
  validate :validate_voucher_value
  validate :validate_lesson_payment, if: -> { from_credited_lesson }

  before_save :set_date
  before_create :set_description, if: -> { from_credited_lesson && description.blank? }
  before_create :do_payment

  private

  def set_date
    self.date = Time.zone.now
  end

  def set_description
    self.description = "Pagamento: #{credited_lesson&.lessons_type&.name}"
  end

  def do_payment
    ActiveRecord::Base.transaction do
      old_voucher_value_used = voucher.value_used
      new_voucher_value_used = old_voucher_value_used + value

      voucher.update(value_used: new_voucher_value_used)

      if from_credited_lesson
        credited_lesson.add_payment(value)
        credited_lesson.save!
      end
    end
  end

  def validate_voucher_value
    old_voucher_value_used = voucher.value_used
    new_voucher_value_used = old_voucher_value_used + value

    if new_voucher_value_used > voucher.value
      errors.add(:value, "ultrapassa o valor disponível do voucher")
    end
  end

  def validate_lesson_payment
    credited_lesson = CreditedLesson.find(credited_lesson_id)
    if value > (credited_lesson.lesson_price - credited_lesson.payment)
      errors.add(:value, "não pode exceder o valor em dívida da aula")
    end
  end
end
