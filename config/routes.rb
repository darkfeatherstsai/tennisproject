Rails.application.routes.draw do
  devise_for :managers
  devise_for :users
  root "rackets#index"

  resources :rackets , :only => [:index ]
  post "webhook", to: "rackets#webhook"
  get "rackets/price_sort_decs" , to: "rackets#price_sort_decs"
  get "rackets/price_sort_acs" , to: "rackets#price_sort_acs"
  get "rackets/label_sort_decs" , to: "rackets#label_sort_decs"
  get "rackets/label_sort_acs" , to: "rackets#label_sort_acs"
  get "rackets/findracket" , to: "rackets#findracket"

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
