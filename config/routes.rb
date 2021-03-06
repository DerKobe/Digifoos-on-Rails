class ExceptGamesGroupsAndUsers
  def self.matches?(request)
    !%w[ /games /groups /users ].include?(request.fullpath)
  end
end

Rails.application.routes.draw do
  devise_for :users

  get '/:id', to: 'groups#show', constraints: ExceptGamesGroupsAndUsers

  resources :groups do
    resources :players

    member do
      post   'games', to: 'games#create',            as: :create_game
      delete 'games', to: 'games#destroy_last_game', as: :destroy_game

      post   'users/:user_id' => 'managers#add',    as: 'add_manager'
      delete 'users/:user_id' => 'managers#remove', as: 'remove_manager'
    end
  end

  resources :games, only: [] do
    member do
      post   'start'
      post   'finish'
      delete 'cancel'

      post   'teams/:team_id', to: 'games#inc_goals', as: :inc_goals
      delete 'teams/:team_id', to: 'games#dec_goals', as: :dec_goals

      post   'teams/:team_id/players/:player_id', to: 'games#set_player',    as: :set_player
      delete 'teams/:team_id/players/:player_id', to: 'games#remove_player', as: :remove_player
    end
  end

  root 'statics#home'
end
