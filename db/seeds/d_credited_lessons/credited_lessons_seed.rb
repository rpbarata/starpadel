# frozen_string_literal: true

if ActiveModel::Type::Boolean.new.cast(ENV.fetch("TESTING", "false")) && !CreditedLesson.any?
  STDOUT.puts("Seeding with CreditedLessons for testing")

  Faker::Config.locale = "en"

  500.times do |_index|
    CreditedLesson.create(
      comments: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10),
      client_id: Client.pluck(:id).sample,
      lessons_type_id:  LessonsType.pluck(:id).sample,
      time_period: [:green_time, :red_time].sample
    )
  end

  CreditedLesson.find_each do |credited_lesson|
    credited_lesson.update(created_at: Faker::Date.between(from: 2.months.ago, to: Time.zone.today))
  end
end
