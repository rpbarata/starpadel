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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#
# Indexes
#
#  index_vouchers_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
class Voucher < ApplicationRecord
  attr_accessor :from_client

  belongs_to :client
  has_many :movements

  validates :value, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :code, presence: true
  validate :validate_validity, if: -> { validity.present? }

  before_validation :generate_code, on: :create

  def format_srt
    "#{client.name} - #{code}"
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
end
