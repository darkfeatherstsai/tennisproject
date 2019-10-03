Rails.application.routes.draw do
  devise_for :managers
  devise_for :users
  root "rackets#index"

  resources :rackets , :only => [:index ]

  post "webhook", to: "rackets#webhook"

  namespace :dashboard do

    resources :rackets
    resources :trackinglists do
      member do
        post :add, path:'add/:id'
        delete :destroy, path:'delete/:id'
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
