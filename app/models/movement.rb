# frozen_string_literal: true

# == Schema Information
#
# Table name: movements
#
#  id                        :bigint           not null, primary key
#  comments                  :text
#  date                      :datetime
#  description               :string
#  from_client_lessons_group :boolean
#  value                     :decimal(8, 2)    default(0.0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  client_id                 :bigint           not null
#  client_lessons_group_id   :bigint
#  voucher_id                :bigint           not null
#
# Indexes
#
#  index_movements_on_client_id                (client_id)
#  index_movements_on_client_lessons_group_id  (client_lessons_group_id)
#  index_movements_on_voucher_id               (voucher_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (client_lessons_group_id => client_lessons_groups.id)
#  fk_rails_...  (voucher_id => vouchers.id)
#
class Movement < ApplicationRecord
  belongs_to :voucher
  belongs_to :client_lessons_group, optional: true
  belongs_to :client

  validates :description, presence: true, if: -> { client_lessons_group_id.blank? }
  validates :value, numericality: { greater_than_or_equal_to: 0 }, presence: true

  before_save :set_date
  after_save :set_description, if: -> { client_lessons_group_id.present? && description.blank? }

  private

  def set_date
    self.date = Time.zone.now
  end

  def set_description
    self.description = "Pagamento #{client_lessons_group&.lessons_type&.name}"

    save!
  end
end
