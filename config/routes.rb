# frozen_string_literal: true

Rails.application.routes.draw do
  root 'films#index'

  resources :film_locations
  resources :films do
    resource :poster, module: :films, only: [:show]
  end

  resources :companies
  resources :locations
  resources :people
end
