ActiveadminDepot::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login
  
  resources :sessions
  resources :admin_users

  root :to => "dashboard#index"

  #get "cart" => "cart#show"
  #get "cart/add/:id" => "cart#add", :as => :add_to_cart
  #post "cart/remove/:id" => "cart#remove", :as => :remove_from_cart
  #post "servico/new" => "service#new", :as => :service_path
end
