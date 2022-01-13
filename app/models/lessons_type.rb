# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons_types
#
#  id                          :bigint           not null, primary key
#  comments                    :text
#  green_time_member_price     :decimal(8, 2)
#  green_time_not_member_price :decimal(8, 2)
#  is_active                   :boolean          default(TRUE)
#  is_pack                     :boolean
#  name                        :string
#  number_of_lessons           :integer
#  red_time_member_price       :decimal(8, 2)
#  red_time_not_member_price   :decimal(8, 2)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_lessons_types_on_is_active  (is_active)
#  index_lessons_types_on_is_pack    (is_pack)
#  index_lessons_types_on_name       (name) UNIQUE
#
class LessonsType < ApplicationRecord
  # has_paper_trail

  has_many :credited_lessons, dependent: :restrict_with_error

  scope :packs, -> { where(is_pack: true) }
  scope :not_packs, -> { where(is_pack: [false, nil, ""]) }
  scope :actives, -> { where(is_active: true) }

  validates :name, uniqueness: true, presence: true
  validates :green_time_member_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :green_time_not_member_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :red_time_member_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :red_time_not_member_price, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :number_of_lessons, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  before_validation :set_number_of_lessons, if: -> { !is_pack }

  def format_number_of_lessons
    is_pack ? number_of_lessons : ""
  end

  private

  def set_number_of_lessons
    self.number_of_lessons = 1
  end
end
