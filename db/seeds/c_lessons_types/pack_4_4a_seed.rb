STDOUT.puts("Seeding with LessonsType PACK DE 4 AULAS 4A")

lessons_type = 
  LessonsType.where(
    name: "PACK DE 4 AULAS 4A"
  ).first_or_initialize(
    green_time_not_member_price: 52.50,
    red_time_not_member_price: 62, 
    green_time_member_price: 49.88,
    red_time_member_price: 58.90,
    is_active: true,
    is_pack: true,
    number_of_lessons: 4,
  )

lessons_type.save!