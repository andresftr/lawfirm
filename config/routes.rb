Rails.application.routes.draw do
  get 'welcome/index'
  
  resources :clients
  resources :attorneys
  resources :affairs
  resources :assignments

  root 'welcome#index'
end
