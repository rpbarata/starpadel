# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def health
    render(json: "OK", status: :ok)
  end

  def after_sign_in_path_for(client)
    clients_path
  end
end
