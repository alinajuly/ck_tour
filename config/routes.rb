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

      get '/toponyms', to: 'toponyms#index'

      resources :tours
      resources :comments
      resources :rates
      resources :places

      root 'attractions#index'
      get 'search', to: 'attractions#search'

      resources :attractions do
        resources :coordinates, only: %i[create]
        get '/coordinates', to: 'coordinates#show'
        put '/coordinates', to: 'coordinates#update'
        delete '/coordinates', to: 'coordinates#destroy'
        resources :toponyms, only: %i[create]
        get '/toponyms', to: 'toponyms#show'
        put '/toponyms', to: 'toponyms#update'
        delete '/toponyms', to: 'toponyms#destroy'
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
        resources :coordinates, only: %i[create]
        get '/coordinates', to: 'coordinates#show'
        put '/coordinates', to: 'coordinates#update'
        delete '/coordinates', to: 'coordinates#destroy'
        resources :toponyms, only: %i[create]
        get '/toponyms', to: 'toponyms#show'
        put '/toponyms', to: 'toponyms#update'
        delete '/toponyms', to: 'toponyms#destroy'
      end

    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root 'api/v1/accommodations#index'
  # root 'authentication#login'
end
