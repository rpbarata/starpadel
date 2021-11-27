# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons
#
#  id              :bigint           not null, primary key
#  comments        :text
#  end_time        :datetime
#  lesson_group    :integer
#  start_time      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#  lessons_type_id :bigint           not null
#
# Indexes
#
#  index_client_lessons_on_client_id        (client_id)
#  index_client_lessons_on_lessons_type_id  (lessons_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
require "rails_helper"

RSpec.describe(ClientLesson, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
