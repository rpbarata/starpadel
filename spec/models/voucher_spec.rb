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
require "rails_helper"

RSpec.describe(Voucher, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
