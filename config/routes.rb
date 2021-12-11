# frozen_string_literal: true

# fix forbidden error - retry buttons
require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :clients
  devise_for :admins

  authenticate :admin do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  get "dashboard", to: "athlete#index"
  root "dashboard_admin/admin#index"
end
