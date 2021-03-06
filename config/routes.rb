Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'#, as: 'helf'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get '/login',	to:'sessions#new'
  post '/login',	to:'sessions#create'
  delete '/logout', 	to:'sessions#destroy'
  #get '/delete',		to:'messages#destroy'
  resources :users do
    member do
      get :following, :followers
      patch :block, :unblock
      resources :messages
    end
  end
  resources :microposts do
  	member do
  		patch :like, :unlike
  	end
  end
  resources :relationships,       only: [:create, :destroy]
end
