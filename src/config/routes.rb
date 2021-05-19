Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'cards#index'
  get '/users/:id/account', to: 'main#account', as: 'user_account'
  get '/cards/new', to: 'cards#new', as: 'new_card'
  get '/card/:id/edit', to: 'cards#edit', as: 'edit_card'
  get '/cards/:id', to: 'cards#show', as: 'card'
  get '/cards', to: 'cards#index', as: 'cards'
  post '/cards', to: 'cards#create'
  delete '/cards/:id', to: 'cards#destroy'
end
