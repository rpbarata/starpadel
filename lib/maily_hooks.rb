# frozen_string_literal: true

client = Client.new(name: Faker::Name.name_with_middle, email: Faker::Internet.email)
Maily.hooks_for("ClientCredentialsMailer") do |mailer|
  mailer.register_hook(
    :first_credentials,
    with_params: { client: client, password: "123456" },
    description: "This email is sent when an Admin generates a client's login credentials for the first time."
  )
end
