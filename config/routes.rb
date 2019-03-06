Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  
  resources :clients
  resources :attorneys
  resources :affairs
  resources :assignments

  root 'welcome#index'
end
