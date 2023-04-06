Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :users do
        put '/change_role', to: 'users#change_role'
      end

      resources :users do
        resources :bookings do
          put '/confirm', to: 'bookings#confirm'
          put '/cancel', to: 'bookings#cancel'
        end
      end

      post '/auth/login', to: 'authentication#login'
      post 'password/forgot', to: 'password#forgot'
      post 'password/reset', to: 'password#reset'

      post 'admins/create_admin', to: 'admins#create_admin'

      resources :tours
      resources :comments
      resources :rates
      resources :places

      root 'attractions#index'
      get 'search', to: 'attractions#search'

      resources :attractions do
        resources :geolocations, only: %i[create]
        get '/geolocations', to: 'geolocations#show'
        put '/geolocations', to: 'geolocations#update'
        delete '/geolocations', to: 'geolocations#destroy'
      end

      resources :accommodations do
        resources :facilities
        resources :rooms do
          resources :amenities
        end
        put '/publish', to: 'accommodations#publish'
        put '/unpublish', to: 'accommodations#unpublish'
      end

      resources :accommodations do
        resources :geolocations, only: %i[create]
        get '/geolocations', to: 'geolocations#show'
        put '/geolocations', to: 'geolocations#update'
        delete '/geolocations', to: 'geolocations#destroy'
      end

      resources :subscriptions
      resources :plans
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'api/v1/accommodations#index'
  # root 'authentication#login'
end
