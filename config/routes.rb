Rails.application.routes.draw do
  resources :purchases
  resources :sales
  resources :items
  devise_for :users
  resources :companies

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Define root path
  root to: "companies#index"
end
