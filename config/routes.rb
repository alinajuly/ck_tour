Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      post '/auth/login', to: 'authentication#login'
      post 'password/forgot', to: 'password#forgot'
      post 'password/reset', to: 'password#reset'

      post 'admins/create_admin', to: 'admins#create_admin'

      resources :users do
        put '/change_role', to: 'users#change_role'
        resources :bookings do
          put '/confirm', to: 'bookings#confirm'
          put '/cancel', to: 'bookings#cancel'
        end
        resources :appointments do
          put '/confirm', to: 'appointments#confirm'
          put '/cancel', to: 'appointments#cancel'
        end
      end

      resources :attractions do
        resources :geolocations, only: %i[create]
        get '/geolocations', to: 'geolocations#show'
        put '/geolocations', to: 'geolocations#update'
        delete '/geolocations', to: 'geolocations#destroy'
      end
      get 'search', to: 'attractions#search'

      resources :accommodations do
        resources :facilities
        resources :rooms do
          resources :amenities
        end
        put '/publish', to: 'accommodations#publish'
        put '/unpublish', to: 'accommodations#unpublish'
        get '/show_unpublished', to: 'accommodations#show_unpublished'
      end
      get 'accommodations_unpublished', to: 'accommodations#index_unpublished'

      resources :accommodations do
        resources :geolocations, only: %i[create]
        get '/geolocations', to: 'geolocations#show'
        put '/geolocations', to: 'geolocations#update'
        delete '/geolocations', to: 'geolocations#destroy'
      end

      resources :tours do
        resources :places do
          resources :geolocations, only: %i[create]
          get '/geolocations', to: 'geolocations#show'
          put '/geolocations', to: 'geolocations#update'
          delete '/geolocations', to: 'geolocations#destroy'
        end
        put '/publish', to: 'tours#publish'
        put '/unpublish', to: 'tours#unpublish'
        get '/show_unpublished', to: 'tours#show_unpublished'
      end
      get 'tours_unpublished', to: 'tours#index_unpublished'

    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'api/v1/attractions#index'
  # root 'authentication#login'
end
