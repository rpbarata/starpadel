STDOUT.puts("Seeding with LessonsType PACK DE 4 AULAS 3A")

lessons_type = 
  LessonsType.where(
    name: "PACK DE 4 AULAS 3A"
  ).first_or_initialize(
    green_time_not_member_price: 65,
    red_time_not_member_price: 80, 
    green_time_member_price: 61.75,
    red_time_member_price: 76,
    is_active: true,
    is_pack: true,
    number_of_lessons: 4,
  )

lessons_type.save!