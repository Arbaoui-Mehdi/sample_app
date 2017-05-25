Rails.application.routes.draw do

  # Home Page
  root             'static_pages#home'

  #
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  # Users
  get 'signup'  => 'users#new'
  resources :users

end
