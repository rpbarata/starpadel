# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons_groups
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
#  index_client_lessons_groups_on_client_id        (client_id)
#  index_client_lessons_groups_on_created_at       (created_at)
#  index_client_lessons_groups_on_lessons_type_id  (lessons_type_id)
#  index_client_lessons_groups_on_time_period      (time_period)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
require "rails_helper"

RSpec.describe(ClientLessonsGroup, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
