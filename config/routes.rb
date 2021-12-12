# frozen_string_literal: true

Rails.application.routes.draw do
  get "health", to: "application#health"
  
  devise_for :clients

  get "dashboard", to: "athlete#index"
  root "dashboard_admin/admin#index"
end
