STDOUT.puts("Seeding with LessonsType PACK DE 4 AULAS")

lessons_type = 
  LessonsType.where(
    name: "PACK DE 4 AULAS"
  ).first_or_initialize(
    green_time_not_member_price: 160.00,
    red_time_not_member_price: 184.00, 
    green_time_member_price: 152,
    red_time_member_price: 174.80,
    is_active: true,
    is_pack: true,
    number_of_lessons: 4,
  )

lessons_type.save!