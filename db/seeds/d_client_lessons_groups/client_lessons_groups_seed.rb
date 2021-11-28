# frozen_string_literal: true

if ActiveModel::Type::Boolean.new.cast(ENV.fetch("SEED_LESSONS", "false")) && !ClientLessonsGroup.any?
  STDOUT.puts("Seeding with ClientLessonsGroups for testing")

  Faker::Config.locale = "en"

  500.times do |_index|
    ClientLessonsGroup.create!(
      comments: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10),
      client_id: Client.pluck(:id).sample,
      lessons_type_id:  LessonsType.pluck(:id).sample,
      time_period: [0, 1].sample
    )
  end

  ClientLessonsGroup.find_each do |client_lessons_group|
    client_lessons_group.update(created_at: Faker::Date.between(from: 2.months.ago, to: Time.zone.today))
  end
end


ClientLessonsGroup.find_each do |client_lessons_group|
  client_lessons_group.update(time_period: [:green_time, :red_time].sample)
end