Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root   "static_pages#home"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
      get 'show_all'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :microposts, only: %i[create update destroy] do
    collection do
      get :news, :trash, :likes
    end

    member do
      patch :toggle_pinned
      post :like
      delete :unlike
    end
  end

  get '/microposts/hashtag/:name' => 'microposts#hashtag'

  resources :microposts, only: [:index]

  resources :relationships,       only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
  
end
