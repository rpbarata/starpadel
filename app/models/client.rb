# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  address                :string
#  become_member_at       :datetime
#  birth_date             :date
#  comments               :text
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  identification_number  :string
#  is_master_member       :boolean          default(FALSE)
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
#  index_clients_on_email                 (email)
#  index_clients_on_name                  (name)
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  scope :members_of_club, -> { where.not(member_id: [nil, ""]) }
  scope :not_members_of_club, -> { where(member_id: [nil, ""]) }
  scope :master_members, -> { where(is_master_member: true) }
  scope :adults, -> { where("birth_date <= :today", today: (Time.now.end_of_day - 18.years))}
  scope :childrens, -> { where("birth_date > :today", today: (Time.now.end_of_day - 18.years))}

  has_paper_trail

  # TODO: Falta ver o tamanho dos nºs de sócio
  validates :name, presence: true
  validates :nif, length: { is: 9 }, numericality: { only_integer: true }, uniqueness: true, if: -> { nif.present? }
  validates :identification_number,
    length: { is: 8 },
    numericality: { only_integer: true },
    uniqueness: true,
    if: -> { identification_number.present? }
  validates :phone_number, phone: true, if: -> { phone_number.present? }
  validates :email, format: { with: /\A[a-z0-9+\-_.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true, if: -> {
                                                                                                         email.present?
                                                                                                       }
  validates :fpp_id, numericality: { only_integer: true }, uniqueness: true, if: -> { fpp_id.present? }
  validates :member_id, numericality: { only_integer: true }, uniqueness: true, if: -> { member_id.present? }
  validate :birth_date_in_the_past, if: -> { birth_date.present? }
  validate :validate_is_master_member, if: -> { is_master_member.present? }

  before_save :set_become_member_at, if: -> { will_save_change_to_member_id? }

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
        all
      end
    end
  end

  def is_adult?
    ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor >= 18
  end

  private

  # on: before_save if: will_save_change_to_member_id?
  def set_become_member_at
    self.become_member_at = member_id.present? ? Time.current : nil
  end

  # validate if birth_date.present?
  def birth_date_in_the_past
    if birth_date >= Time.zone.today.beginning_of_day
      errors.add(:birth_date, "não é válida")
    end
  end

  def validate_is_master_member
    if is_master_member.present? && !member_id.present?
      errors.add(:is_master_member, "deve ser sócio")
    end
  end
end
