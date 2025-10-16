Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # User Profile
      get "profile", to: "profiles#show"
      put "profile", to: "profiles#update"
  # Authentication
  post   "/signup", to: "users#create"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get    "/me",     to: "users#show"

  # Recipes
  get "/recipes/search", to: "recipes#search"
  get "/recipes/search_by_ingredient", to: "recipes#search_by_ingredient"
  get "recipes/:id", to: "recipes#show"
  resources :recipes, only: [:show, :index]

  #favorites
  resources :favorites, only: [:index, :create, :destroy]

  # Planner_Items
  resources :planner_items, only: [:index, :create, :update, :destroy]
    end
  end
end