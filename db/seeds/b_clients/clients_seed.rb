# frozen_string_literal: true

if ActiveModel::Type::Boolean.new.cast(ENV.fetch("SEED_CLIENTS", "false")) && !Client.any?
  STDOUT.puts("Creating Secretariat Admin")

  Faker::Config.locale = "en"

  500.times do |index|
    Client.create!(client_hash(index))
  end

  Client.find_each.with_index do |client, index|
    # Faker::Config.random = Random.new(index)
    created_at_random_date = Faker::Date.between(from: 31.days.ago, to: Time.zone.today)

    become_member_at_random_date =
      if client.member_id.present?
        # Faker::Config.random = Random.new(index)
        Faker::Date.between(from: created_at_random_date, to: Time.zone.today)
      end
    client.update(created_at: created_at_random_date, become_member_at: become_member_at_random_date)
  end
end

def client_hash(seed)
  Faker::Config.random = Random.new(seed)
  is_member = Faker::Boolean.boolean(true_ratio: 0.7)

  Faker::Config.random = Random.new(seed)
  address = Faker::Address.full_address

  Faker::Config.random = Random.new(seed)
  birth_date = Faker::Date.birthday(min_age: 8, max_age: 80)

  Faker::Config.random = Random.new(seed)
  email = Faker::Internet.email

  Faker::Config.random = Random.new(seed)
  fpp_id = Faker::Boolean.boolean(true_ratio: 0.45) ? Faker::Number.number(digits: 4) : nil

  Faker::Config.random = Random.new(seed)
  identification_number = Faker::Number.number(digits: 8)

  Faker::Config.random = Random.new(seed)
  member_id = is_member ? Faker::Number.number(digits: 5) : nil

  Faker::Config.random = Random.new(seed)
  name = Faker::Name.name_with_middle

  Faker::Config.random = Random.new(seed)
  nif = Faker::Number.number(digits: 9)

  # Faker::Config.random = Random.new(seed)
  # phone_number: Faker::PhoneNumber.cell_phone_in_e164

  Faker::Config.random = Random.new(seed)
  comments = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10)

  Faker::Config.random = Random.new(seed)
  is_master_member = is_member ? Faker::Boolean.boolean(true_ratio: 0.3) : false

  {
    address: address,
    birth_date: birth_date,
    email: email,
    fpp_id: fpp_id,
    identification_number: identification_number,
    member_id: member_id,
    name: name,
    nif: nif,
    # phone_number: phone_number,
    comments: comments,
    is_master_member: is_master_member,
  }
end
