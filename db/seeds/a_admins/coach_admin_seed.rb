# frozen_string_literal: true

Rails.logger.debug("Creating Coach Admin")

admin = Admin.where(
  username: "treinadores"
).first_or_initialize(
  email: "treinadores@mail.com",
  username: "treinadores",
  password: ENV["ADMIN_PASSWORD"],
  password_confirmation: ENV["ADMIN_PASSWORD"],
  role: :coach_admin
)

if admin.present?
  admin.update(
    email: "treinadores@mail.com",
    username: "treinadores",
    password: ENV["ADMIN_PASSWORD"],
    password_confirmation: ENV["ADMIN_PASSWORD"],
    role: :coach_admin
  )
else
  admin.skip_confirmation!
  admin.save!
end
