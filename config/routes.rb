Photoapp::Application.routes.draw do
  devise_for :users
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  resources :users
  resources :photos do
    member do
      get 'image'
    end
  end
  root to: 'photos#index'
end
