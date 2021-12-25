# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :clients # , skip: [:registrations]
  # as :client do
  #   get 'clients/edit' => 'devise/registrations#edit', :as => 'edit_client_registration'
  # end

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
