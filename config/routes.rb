# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root 'films#index'

  resources :films do
    resource :poster, module: :films, only: [:show]
  end

  resources :companies
  resources :locations
  resources :people
end
