Rails.application.routes.draw do
  devise_for :managers
  devise_for :users
  root "rockets#index"

  resources :rockets , :only => [:index , :show]

  namespace :dashboard do

    resources :rockets
    resources :trackinglists

    namespace :admin, path: "sj3xu418" do
      resources :rockets
      resources :trackinglists
      resources :users
      resources :managers

    end
  end
end
