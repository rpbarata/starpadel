# frozen_string_literal: true

class ClientCredentialsMailer < ApplicationMailer
  def first_credentials
    @client = params[:client]
    @password = params[:password]
    @url = ENV.fetch("HOST", "")
    mail(to: @client.email, subject: "Novas Credenciais de Acesso")
  end
end
