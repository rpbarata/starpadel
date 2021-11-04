# frozen_string_literal: true

STDOUT.puts("Creating Secretariat Admin")

admin = Admin.where(
  username: "balcao"
).first_or_initialize(
  email: "balcao@mail.com",
  username: "balcao",
  password: ENV["ADMIN_PASSWORD"],
  password_confirmation: ENV["ADMIN_PASSWORD"],
  role: :secretariat_admin
)

if admin.present?
  admin.update(
    email: "balcao@mail.com",
    username: "balcao",
    password: ENV["ADMIN_PASSWORD"],
    password_confirmation: ENV["ADMIN_PASSWORD"],
    role: :secretariat_admin
  )
else
  admin.skip_confirmation!
  admin.save!
end
