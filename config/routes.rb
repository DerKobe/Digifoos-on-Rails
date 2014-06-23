Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    resources :players, except: :index
    resources :games, except: :index
  end

  root 'statics#home'
end
