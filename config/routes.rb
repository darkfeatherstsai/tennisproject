Rails.application.routes.draw do
  devise_for :managers
  devise_for :users
  root "rackets#index"

  resources :rackets , :only => [:index , :show]

  namespace :dashboard do

    resources :rackets
    resource :trackinglists do
      collection do
        post :add, path:'add/:id'
      end
    end

    namespace :admin, path: "sj3xu418" do
      resources :rackets
      resources :trackinglists
      resources :users
      resources :managers

    end
  end
end
