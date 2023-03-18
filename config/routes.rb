Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users
      post '/auth/login', to: 'authentication#login'
      post 'password/forgot', to: 'password#forgot'
      post 'password/reset', to: 'password#reset'
      resources :partners
      post '/auth/login', to: 'authentication#login'
      resources :tours
      resources :comments
      resources :rates
      resources :tags
      resources :places

      resources :accommodations do
        resources :facilities
        resources :rooms do
          resources :amenities
        end
      end

      resources :accommodations do
        resources :coordinates
      end

      resources :users do
        resources :bookings
      end

    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'api/v1/accommodations#index'
  # root 'authentication#login'
end
