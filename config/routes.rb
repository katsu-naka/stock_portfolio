Rails.application.routes.draw do
  get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "products#index"
  resources :products do
    resources :likes, only: [:create, :destroy]
  end
  resources :users
end
