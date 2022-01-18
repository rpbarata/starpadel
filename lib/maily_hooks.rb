# frozen_string_literal: true

client = Client.new(name: Faker::Name.name_with_middle, email: Faker::Internet.email)
Maily.hooks_for("ClientCredentialsMailer") do |mailer|
  mailer.register_hook(
    :first_credentials,
    with_params: { client: client, password: "123456" },
    description: "This email is sent when an Admin generates a client's login credentials for the first time."
  )
  mailer.register_hook(
    :new_credentials,
    with_params: { client: client, password: "123456" },
    description: "This email is sent when an Admin generates a client's login credentials for the first time."
  )
end

Maily.hooks_for("Devise::Mailer") do |mailer|
  mailer.register_hook(:reset_password_instructions, client, "random_token")
  mailer.register_hook(:password_change, client)

  mailer.hide_email(:unlock_instructions)
  mailer.hide_email(:confirmation_instructions)
  mailer.hide_email(:email_changed)
end
