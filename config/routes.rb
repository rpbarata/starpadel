# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :clients
  devise_for :admins

  root "admins_admin/admin#index"
end
