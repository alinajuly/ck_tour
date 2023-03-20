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
      resources :tours
      resources :comments
      resources :rates
      resources :places

      resources :attractions do
        resources :coordinates
        resources :toponyms
      end

      get 'search', to: 'attractions#search'

      resources :accommodations do
        resources :facilities
        resources :rooms do
          resources :amenities
        end
      end

      resources :accommodations do
        resources :coordinates
        resources :toponyms
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
