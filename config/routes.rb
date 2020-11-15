Rails.application.routes.draw do
  root to: "productions#index"
  resources :production
end
