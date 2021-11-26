# frozen_string_literal: true

def create_admin(username, email, password, role)
  admin = Admin.where(
    username: username
  ).first_or_initialize(
    email: email,
    username: username,
    password: password,
    password_confirmation: password,
    role: role
  )

  if admin.present?
    admin.update(
      email: email,
      username: username,
      password: password,
      password_confirmation: password,
      role: role
    )
  else
    admin.skip_confirmation!
    admin.save!
  end
end

STDOUT.puts("Verifying Dev Team Admins")
create_admin(ENV["DEV_TEAM_ADMIN_USERNAME"], ENV["DEV_TEAM_ADMIN_EMAIL"], ENV["DEV_ADMIN_PASSWORD"], :super_admin)
