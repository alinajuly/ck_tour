Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tours
      resources :events
      resources :comments
      resources :rates
      resources :tags
      resources :places
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'api/v1/places#index'
end
