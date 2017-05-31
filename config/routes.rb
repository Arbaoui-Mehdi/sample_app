Rails.application.routes.draw do

  #
  #
  #
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'account_activations/edit'
  get 'sessions/new'

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
  resources :users

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

end
