Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users
      post '/auth/login', to: 'authentication#login'
      resources :password_resets
      post 'password_resets/:token', to: 'password_resets#password_reset'
      resources :partners
      post '/auth/login', to: 'authentication#login'
      resources :tours
      resources :comments
      resources :rates
      resources :tags
      resources :places

      resources :accommodations do
        resources :rooms
      end

      resources :accommodations do
        resources :coordinates
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'api/v1/accommodations#index'
  # root 'authentication#login'
end
