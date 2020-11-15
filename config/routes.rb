Rails.application.routes.draw do
  devise_for :users
  root to: "productions#index"
  resources :production
end
