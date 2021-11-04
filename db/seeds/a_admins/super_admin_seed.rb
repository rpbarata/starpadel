# frozen_string_literal: true

STDOUT.puts("Creating Super Admins")

def create_super_admin(username, email, password)
  admin = Admin.where(
    username: username
  ).first_or_initialize(
    email: email,
    username: username,
    password: password,
    password_confirmation: password,
    role: :super_admin
  )

  if admin.present?
    admin.update(
      email: email,
      username: username,
      password: password,
      password_confirmation: password,
      role: :super_admin
    )
  else
    admin.skip_confirmation!
    admin.save!
  end
end

create_super_admin(ENV["ADMIN_USERNAME"], ENV["ADMIN_EMAIL"], ENV["ADMIN_PASSWORD"])
create_super_admin("rui.barata", "ruipbarata@gmail.com", "meidei123")
create_super_admin("diogo.boinas", "boinas@student.dei.uc.pt", "meidei123")
create_super_admin("marco.neto", "uc2020207902@student.uc.pt", "meidei123")
create_super_admin("diogo.antunes", "djantunes@student.dei.uc.pt", "meidei123")
create_super_admin("jose.simoes", "josesimoes@student.dei.uc", "meidei123")
create_super_admin("laura.jaime", "uc2020202485@student.uc.pt", "meidei123")
create_super_admin("sergio.machado", "smachado@student.dei.uc.pt", "meidei123")
create_super_admin("darcy.bai", "dmarceta@student.dei.uc.pt", "meidei123")
create_super_admin("bruno.ferreira", "brunof@student.dei.uc.pt", "meidei123")
create_super_admin("soumaya.labbene", "soumaya.labbene@medtech.tn", "meidei123")
