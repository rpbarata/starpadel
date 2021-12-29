# frozen_string_literal: true

if ActiveModel::Type::Boolean.new.cast(ENV.fetch("TESTING", "false")) && !Voucher.any?
  STDOUT.puts("Seeding with Vouchers for testing")

  Faker::Config.locale = "en"

  500.times do |_index|
    voucher = Voucher.new(
      comments: Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 10),
      client_id: Client.pluck(:id).sample,
      validity: if Faker::Boolean.boolean(true_ratio: 0.7)
                  Faker::Date.between(from: 20.days.ago,
                    to: (Time.zone.today + 5.months))
                end,
      value: Faker::Number.between(from: 20, to: 500),
    )

    voucher.save(perform_validation: false)
  end

  Voucher.find_each do |voucher|
    voucher.update(created_at: Faker::Date.between(from: 1.month.ago, to: Time.zone.today))
  end
end
