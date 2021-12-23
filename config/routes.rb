# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :clients

  namespace :clients do
    get "/", to: "client#index"
    resources :credited_lessons, only: [:index] do
      resources :lessons, only: [:index]
    end
    resources :vouchers, only: [:index] do
      resources :movements, only: [:index]
    end
  end

  get "home/index"
  get "health", to: "application#health"

  # root "dashboard_admin/admin#index"
  root "home#index"
end
