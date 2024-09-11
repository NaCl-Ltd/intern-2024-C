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
      get :following, :followers, :show_all
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :microposts, only: %i[index show create update destroy] do
    collection do
      get :news, :trash, :likes
    end

    member do
      patch :toggle_pinned
      post :like
      delete :unlike
    end
  end

  resources :relationships,       only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
