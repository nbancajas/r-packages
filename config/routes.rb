require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :packages, only: [:index, :show]

  root to: 'packages#index'
end
