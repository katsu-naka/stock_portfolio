Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "products#index"
  resources :products
  resources :users
end
