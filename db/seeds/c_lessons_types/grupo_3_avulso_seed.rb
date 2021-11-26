STDOUT.puts("Seeding with LessonsType GRUPO 3 avulso")

lessons_type = 
  LessonsType.where(
    name: "GRUPO 3 avulso"
  ).first_or_initialize(
    green_time_not_member_price: 20,
    red_time_not_member_price: 25, 
    green_time_member_price: 19,
    red_time_member_price: 23.75,
    is_active: true,
    is_pack: false,
    number_of_lessons: 1,
  )

lessons_type.save!