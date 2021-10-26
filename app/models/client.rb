# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  address                :string
#  birth_date             :date
#  comments               :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  identification_number  :string
#  name                   :string
#  nif                    :string
#  phone_number           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rfid_number            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fpp_id                 :string
#  member_id              :string
#
# Indexes
#
#  index_clients_on_email                 (email) UNIQUE
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  scope :members_of_club, -> { where.not(member_id: [nil, ""]) }
  scope :not_members_of_club, -> { where(member_id: [nil, ""]) }

  # TODO Falta ver o tamanho dos nºs de sócio
  validates :name, presence: true
  validates :nif, length: { is: 9 }, numericality: { only_integer: true }, if: -> { nif.present? }
  validates :identification_number, length: { is: 8 }, numericality: { only_integer: true }, if: -> { identification_number.present? }
  validates :phone_number, phone: true, if: -> { phone_number.present? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :fpp_id, numericality: { only_integer: true }, if: -> { fpp_id.present? }
  validates :member_id, numericality: { only_integer: true }, if: -> { member_id.present? }

  class << self
    # TODO Ver porquê que as data não estão a funcionar bem
    def select_by_date(start_date, end_date)
      if start_date.present? && end_date.present?
        where("created_at >= :start_date AND created_at <= :end_date", start_date: start_date, end_date: end_date).distinct
      elsif start_date.present?
        where("created_at >= :start_date", start_date: start_date).distinct
      elsif end_date.present?
        where("created_at <= :end_date", end_date: end_date).distinct
      else
        where(created_at: [(Time.current - 6.months)..(Time.current)])
      end
    end
  end
end
