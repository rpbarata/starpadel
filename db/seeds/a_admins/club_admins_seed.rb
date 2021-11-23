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


STDOUT.puts("Verifying Club Super Admin")
create_admin(ENV["CLUB_SUPER_ADMIN_USERNAME"], ENV["CLUB_SUPER_ADMIN_EMAIL"], ENV["CLUB_SUPER_ADMIN_PASSWORD"], :super_admin)

STDOUT.puts("Verifying Secretariat Admin")
create_admin(ENV["CLUB_SECRETARIAT_ADMIN_USERNAME"], ENV["CLUB_SECRETARIAT_ADMIN_EMAIL"], ENV["CLUB_SECRETARIAT_ADMIN_PASSWORD"], :secretariat_admin)

STDOUT.puts("Verifying Coach Admin")
create_admin(ENV["CLUB_COACH_ADMIN_USERNAME"], ENV["CLUB_COACH_ADMIN_EMAIL"], ENV["CLUB_COACH_ADMIN_PASSWORD"], :coach_admin)
