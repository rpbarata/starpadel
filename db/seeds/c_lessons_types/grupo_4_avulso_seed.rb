# frozen_string_literal: true

STDOUT.puts("Seeding with LessonsType GRUPO 4 avulso")

lessons_type =
  LessonsType.where(
    name: "GRUPO 4 avulso"
  ).first_or_initialize(
    green_time_not_member_price: 16,
    red_time_not_member_price: 18.50,
    green_time_member_price: 15.20,
    red_time_member_price: 17.58,
    is_active: true,
    is_pack: false,
    number_of_lessons: 1,
  )

lessons_type.save!
