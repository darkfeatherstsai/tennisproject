Rails.application.routes.draw do
  devise_for :managers
  devise_for :users
  resources :statics , :only => [:index]
  root "statics#index"

  resources :rockets , :only => [:index , :show]

  namespace :dashboard do

    resources :rockets

    namespace :qnklkfdiosidfho do
      resources :rockets
      resources :trackinglists
      resources :users
      resources :managers

    end
  end
end
