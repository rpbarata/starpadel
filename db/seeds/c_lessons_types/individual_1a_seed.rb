STDOUT.puts("Seeding with LessonsType INDIVIDUAL avulso")

lessons_type = 
  LessonsType.where(
    name: "INDIVIDUAL avulso"
  ).first_or_initialize(
    green_time_not_member_price: 45.00,
    red_time_not_member_price: 55.00, 
    green_time_member_price: 42.75,
    red_time_member_price: 52.25,
    is_active: true,
    is_pack: false,
    number_of_lessons: 1,
  )

lessons_type.save!