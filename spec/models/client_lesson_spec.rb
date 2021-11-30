# frozen_string_literal: true

# == Schema Information
#
# Table name: client_lessons
#
#  id                      :bigint           not null, primary key
#  comments                :text
#  end_time                :datetime
#  start_time              :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  client_id               :bigint           not null
#  client_lessons_group_id :bigint           not null
#  lessons_type_id         :bigint           not null
#
# Indexes
#
#  index_client_lessons_on_client_id                (client_id)
#  index_client_lessons_on_client_lessons_group_id  (client_lessons_group_id)
#  index_client_lessons_on_created_at               (created_at)
#  index_client_lessons_on_end_time                 (end_time)
#  index_client_lessons_on_lessons_type_id          (lessons_type_id)
#  index_client_lessons_on_start_time               (start_time)
#  index_client_lessons_on_start_time_and_end_time  (start_time,end_time)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (client_lessons_group_id => client_lessons_groups.id)
#  fk_rails_...  (lessons_type_id => lessons_types.id)
#
require "rails_helper"

RSpec.describe(ClientLesson, type: :model) do
  pending "add some examples to (or delete) #{__FILE__}"
end
