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

STDOUT.puts("Verifying Club Super Admin")
create_admin(ENV["CLUB_SUPER_ADMIN_USERNAME"], ENV["CLUB_PASSWORD"], :super_admin)

STDOUT.puts("Verifying Secretariat Admin")
create_admin(ENV["CLUB_SECRETARIAT_ADMIN_USERNAME"], ENV["CLUB_PASSWORD"], :secretariat_admin)

STDOUT.puts("Verifying Coach Admin")
create_admin(ENV["CLUB_COACH_ADMIN_USERNAME"], ENV["CLUB_PASSWORD"], :coach_admin)
