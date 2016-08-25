Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :rides, only: [:new, :create, :show]  do
    post 'price_estimate', to: 'rides#price_estimate'
    post 'request', to: 'rides#ride_request'
    patch 'edit_status', to: 'rides#edit_status'
    patch 'cancel_request', to: 'rides#cancel_request'
  end
end
