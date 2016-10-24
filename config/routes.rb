Rails.application.routes.draw do
  get "static_pages/home"
  root "static_pages#home"
  resources :users
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
end
