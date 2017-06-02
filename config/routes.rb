Rails.application.routes.draw do

  #
  #
  # Home Page
  root             'static_pages#home'

  #
  #
  # Static Pages
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  #
  #
  # User Sign Up
  get 'signup'  => 'users#new'

  #
  #
  # Users
  resources :users do
    member do
      get :following, :followers
    end
  end

  #
  #
  # Sessions
  get    'login'    => 'sessions#new'   # page for a new session (login)
  post   'login'    => 'sessions#create'  # Create a new session (login)
  delete 'logout'   => 'sessions#destroy' # Delete a session (log out)

  #
  #
  # Account Activations
  resources :account_activations, only: [:edit]

  #
  #
  # Password Reset
  get 'password_resets' => 'password_resets#new'
  resources :password_resets, only: [:new, :create, :edit, :update]

  #
  #
  # Microposts
  resources :microposts, only: [:create, :destroy]

  #
  #
  # Relationships
  resources :relationships, only: [:create, :destroy]

end
