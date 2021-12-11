# frozen_string_literal: true

def create_admin(username, password, role)
  admin = Admin.where(
    username: username
  ).first_or_initialize(
    username: username,
    password: password,
    role: role
  )

  if admin.present?
    admin.update(
      username: username,
      password: password,
      role: role
    )
  else
    admin.skip_confirmation!
    admin.save!
  end
end

STDOUT.puts("Verifying Dev Team Admins")
create_admin(ENV["DEV_TEAM_ADMIN_USERNAME"], ENV["DEV_ADMIN_PASSWORD"], :super_admin)
