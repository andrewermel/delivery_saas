Rails.application.routes.draw do
  resources :purchases
  resources :sales
  resources :items
  resources :inventories, only: [:index] do
    collection do
      get :show_transactions
    end
  end
  devise_for :users
  resources :companies

  # Pages routes
  get "dashboard", to: "pages#dashboard", as: :dashboard
  get "home", to: "pages#home", as: :home

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Define root path
  root to: "pages#home"
end
