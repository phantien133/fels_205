Rails.application.routes.draw do
  get "static_pages/home"
  root "static_pages#home"

  resources :users do
    resources :following, only: :index
    resources :followers, only: :index
  end

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :categories

  resources :lessons do
    resources :results
    post "start_lesson", to: "results#create"
    get "test", to: "results#edit"
    post "test", to: "results#update"
  end

  resources :words
  post "create_word", to: "words#create"

  resources :relationships, only: [:create, :destroy]
end
