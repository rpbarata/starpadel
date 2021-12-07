# frozen_string_literal: true

# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  code       :string
#  comments   :text
#  validity   :datetime
#  value      :decimal(8, 2)    default(0.0)
#  value_used :decimal(, )      default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_vouchers_on_client_id             (client_id)
#  index_vouchers_on_code                  (code) UNIQUE
#  index_vouchers_on_validity              (validity)
#  index_vouchers_on_value                 (value)
#  index_vouchers_on_value_and_value_used  (value,value_used)
#  index_vouchers_on_value_used            (value_used)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Voucher < ApplicationRecord
  has_paper_trail

  attr_accessor :from_client

  belongs_to :client
  has_many :movements, dependent: :destroy

  scope :expired, -> { where("validity <= :today", today: Time.zone.now) }
  scope :not_expired, -> {
                        (where("validity > :today", today: Time.zone.now).or(where(validity: nil)))
                          .and(where("value_used < value"))
                      }
  scope :fully_used, -> { where("value = value_used") }

  validates :value, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :code, presence: true
  validate :validate_validity, if: -> { validity.present? }
  validate :use_voucher

  before_validation :generate_code, on: :create

  class << self
    def select_by_date(start_date, end_date)
      if start_date.present? && end_date.present?
        where("created_at BETWEEN :start_date AND :end_date",
          start_date: start_date.beginning_of_day, end_date: end_date.end_of_day).distinct
      elsif start_date.present?
        where("created_at > :start_date", start_date: start_date.beginning_of_day).distinct
      elsif end_date.present?
        where("created_at < :end_date", end_date: end_date.end_of_day).distinct
      else
        where("created_at BETWEEN :start_date AND :end_date",
          start_date: (Time.zone.now.beginning_of_day - 31.days), end_date: Time.zone.now.end_of_day).distinct
      end
    end
  end

  def format_srt
    # "#{client.name} - #{code} (€#{value_remaining})"
    "#{code} (€#{value_remaining})"
  end

  def formated_validity
    validity.presence || "Sem validade"
  end

  def expired?
    validity <= Time.zone.now
  end

  # def value_used
  #   movements.sum(:value)
  # end

  def value_remaining
    value - value_used
  end

  def fully_used?
    value == value_used
  end

  private

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(6).upcase
      break unless Voucher.exists?(code: code)
    end
  end

  def validate_validity
    if validity < Time.zone.now
      errors.add(:validity, "já passou")
    end
  end

  def use_voucher
    if value_used > value
      errors.add(:general, "o valor usado ultrapassa o valor do voucher")
    end
  end
end
