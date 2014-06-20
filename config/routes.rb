Rails.application.routes.draw do
  devise_for :users

  resources :sessions

  root 'statics#home'
end
