STDOUT.puts("Seeding with LessonsType GRUPO 2 avulso")

lessons_type = 
  LessonsType.where(
    name: "GRUPO 2 avulso"
  ).first_or_initialize(
    green_time_not_member_price: 25,
    red_time_not_member_price: 35.50, 
    green_time_member_price: 23.75,
    red_time_member_price: 30.88,
    is_active: true,
    is_pack: false,
    number_of_lessons: 1,
  )

lessons_type.save!