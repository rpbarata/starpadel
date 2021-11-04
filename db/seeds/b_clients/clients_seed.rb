# frozen_string_literal: true

if ActiveModel::Type::Boolean.new.cast(ENV.fetch("SEED_CLIENTS", "false"))
  STDOUT.puts("Creating Secretariat Admin")

  Faker::Config.locale = "en"

  500.times do |_i|
    Client.create!(
      address: Faker::Address.full_address,
      birth_date: Faker::Date.birthday(min_age: 8, max_age: 80),
      email: Faker::Internet.unique.email,
      fpp_id: [true, false].sample ? Faker::Number.unique.number(digits: 5) : nil,
      identification_number: Faker::Number.unique.number(digits: 8),
      member_id: [true, false].sample ? Faker::Number.unique.number(digits: 4) : nil,
      name: Faker::Name.name_with_middle,
      nif: Faker::Number.unique.number(digits: 9),
      # phone_number: Faker::PhoneNumber.cell_phone_in_e164,
      comments: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10)
    )
  end

  Client.find_each do |client|
    created_at_random_date = Faker::Date.between(from: 31.days.ago, to: Time.zone.today)
    become_member_at_random_date =
      if client.member_id.present?
        Faker::Date.between(from: created_at_random_date, to: Time.zone.today)
      else
        nil
      end
    client.update(created_at: created_at_random_date, become_member_at: become_member_at_random_date)
  end
end
