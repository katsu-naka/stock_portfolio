Rails.application.routes.draw do
  # get 'users/show'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "products#index"
  resources :products do
    resources :comments, only: [:new, :create ]
  end
  resources :users do
    resources :contacts
  end
  post 'like/:id' => 'likes#create', as: 'create_like'
  delete 'like/:id' => 'likes#destroy', as: 'destroy_like'
end
