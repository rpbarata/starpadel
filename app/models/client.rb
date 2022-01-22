# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(FALSE)
#  address                :string
#  avatar_last_update     :datetime
#  become_member_at       :datetime
#  birth_date             :date
#  comments               :text
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  identification_number  :string
#  is_deleted             :boolean          default(FALSE)
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
#  fpp_id                 :integer
#  member_id              :integer
#
# Indexes
#
#  index_clients_on_birth_date            (birth_date)
#  index_clients_on_created_at            (created_at)
#  index_clients_on_email                 (email)
#  index_clients_on_is_master_member      (is_master_member)
#  index_clients_on_member_id             (member_id)
#  index_clients_on_name                  (name)
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :trackable and :omniauthable, :validatable

  devise :database_authenticatable, :validatable, :registerable, :timeoutable, :rememberable, :recoverable

  attr_accessor :skip_password_validation, :will_save_change_to_avatar, :send_password_change_notification_flag,
    :skip_email_validation

  has_one_attached :avatar
  has_many :credited_lessons, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :movements, dependent: :destroy

  scope :members_of_club, -> { where.not(member_id: nil) }
  scope :not_members_of_club, -> { where(member_id: nil) }
  scope :master_members, -> { where(is_master_member: true) }
  scope :adults, -> { where("birth_date <= :today", today: (Time.zone.now.end_of_day - 18.years)) }
  scope :childrens, -> { where("birth_date > :today", today: (Time.zone.now.end_of_day - 18.years)) }
  scope :non_actives, -> { where(is_deleted: true) }

  default_scope { where(is_deleted: false) }

  # has_paper_trail

  # TODO: Falta ver o tamanho dos nºs de sócio
  validates :name, presence: true
  validates :nif,
    length: { is: 9 },
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: true, if: -> { nif.present? }
  validates :identification_number,
    length: { is: 8 },
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    uniqueness: true,
    if: -> { identification_number.present? }
  validates :phone_number, phone: true, if: -> { phone_number.present? }
  validates :email,
    format: { with: /\A[a-z0-9+\-_.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true,
    if: -> { email.present? }
  validates :fpp_id,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: true, if: -> { fpp_id.present? }
  validates :member_id,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: true, if: -> { member_id.present? }
  validate :birth_date_in_the_past, if: -> { birth_date.present? }
  validate :validate_is_master_member, if: -> { is_master_member.present? }
  validates :avatar, aspect_ratio: :square
  validate :validates_avatar_last_update, if: -> { will_save_change_to_avatar }

  after_initialize :set_default_send_password_change_notification_flag
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
        where("created_at BETWEEN :start_date AND :end_date",
          start_date: (Time.zone.now.beginning_of_day - 31.days), end_date: Time.zone.now.end_of_day).distinct
      end
    end
  end

  def adult?
    birth_date.present? && ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor >= 18
  end

  def anonymise
    self.name = "Anónimo"
    self.address = nil
    self.become_member_at = nil
    self.birth_date = nil
    self.comments = nil
    self.email = nil
    self.identification_number = nil
    self.is_master_member = nil
    self.nif = nil
    self.phone_number = nil
    self.remember_created_at = nil
    self.reset_password_sent_at = nil
    self.reset_password_token = nil
    self.rfid_number = nil
    self.fpp_id = nil
    self.member_id = nil
    self.active = false

    self.is_deleted = true

    self.skip_email_validation = true

    save!
  end

  def generate_new_credentials
    password =
      if ActiveModel::Type::Boolean.new.cast(ENV.fetch("TESTING", "false"))
        "123456"
      else
        SecureRandom.base64(10)
      end

    self.password = password
    self.password_confirmation = password
    self.active = true

    password
  end

  def send_reset_password_instructions
    unless active
      errors.add(:email, "A sua conta ainda não está ativa.")
      return false
    end
    super
  end

  def active_for_authentication?
    super && active
  end

  def send_password_change_notification
    return false unless send_password_change_notification_flag
    super
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
    if member_id.blank?
      errors.add(:is_master_member, "deve ser sócio")
    end
  end

  def validates_avatar_last_update
    if avatar_last_update.present? && (avatar_last_update > (Time.zone.now - 31.days))
      errors.add(:avatar, "só pode ser alterado uma vez por cada 31 dias")
    else
      self.avatar_last_update = Time.zone.now
    end
  end

  def set_default_send_password_change_notification_flag
    @send_password_change_notification_flag = true
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  def email_required?
    !skip_email_validation
  end
end
