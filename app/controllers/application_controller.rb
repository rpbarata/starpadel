# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_sentry_user

  def health
    render(json: "OK", status: :ok)
  end

  def after_sign_in_path_for(client)
    clients_path
  end

  def set_sentry_user
    if current_client.present?
      Sentry.set_user(username: current_client.name, id: current_client.id)
    end
  end
end
