# frozen_string_literal: true

Rails.application.routes.draw do
  mount Maily::Engine, at: "/maily"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :clients

  namespace :clients do
    get "/", to: "client#index"
    # get "/calendar", to: "calendar#index"

    resources :credited_lessons, only: [:index] do
      resources :lessons, only: [:index]
    end
    resources :vouchers, only: [:index] do
      resources :movements, only: [:index]
    end
  end

  # get "home/index"
  get "health", to: "application#health"
  get "cookies_policy", to: "static_pages#cookies_policy"

  # root "dashboard_admin/admin#index"
  root "clients/client#index"
end
