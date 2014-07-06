Rails.application.routes.draw do
  devise_for :users

  resources :groups do
    resources :players, except: :index

    member do
      post 'games', to: 'games#create', as: :create_game
    end
  end

  resources :games, only: [] do
    member do
      post   'start'
      post   'finish'
      delete 'cancel'
      post   'teams/:team_id/players/:player_id', to: 'games#set_player',    as: :set_player
      delete 'teams/:team_id/players/:player_id', to: 'games#remove_player', as: :remove_player
    end
  end

  root 'statics#home'
end
