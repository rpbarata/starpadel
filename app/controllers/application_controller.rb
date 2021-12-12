# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def health
    render(json: "OK", status: :ok)
  end
end
