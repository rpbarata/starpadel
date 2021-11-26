STDOUT.puts("Seeding with LessonsType PACK DE 4 AULAS 2A")

lessons_type = 
  LessonsType.where(
    name: "PACK DE 4 AULAS 2A"
  ).first_or_initialize(
    green_time_not_member_price: 83,
    red_time_not_member_price: 113, 
    green_time_member_price: 78.85,
    red_time_member_price: 107.35,
    is_active: true,
    is_pack: true,
    number_of_lessons: 4,
  )

lessons_type.save!