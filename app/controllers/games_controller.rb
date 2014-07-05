class GamesController < ApplicationController
  load_resource except: :create
  before_filter :load_and_authorize_group

  # POST /groups/:group_id/games
  def create
    flash = {}

    if GamesService.open_game_for(@group).present?
      flash[:alert] = 'There already is a not finished game. Finish it first before you start a new one.'
    else
      game = @group.games.create!
      game.teams.create!
      game.teams.create!

      flash[:notice] = 'A new game was successfuly started!'
    end

    redirect_to @group, flash
  end

  # POST /games/:id/start
  def start
    @game.start!
    render 'open_game'
  end

  # POST /games/:id/canel
  def cancel
    @game.destroy!
    render 'cancel_game'
  end

  # POST /games/:id/finish
  def finish
  end

  # POST /games/:id/players/:player_id
  def set_player
    player_operation do |team, player|
      team.players << player if team.players.count < 2 && !team.players.include?(player) && !(@game.teams - [team]).first.players.include?(player)
    end

    render 'open_game'
  end

  # DELETE /games/:id/players/:player_id
  def remove_player
    player_operation do |team, player|
      team.players.delete(player) if player.present?
    end

    render 'created_game'
  end

  # POST /games/:id/teams/:team_id/goals/:action => ['inc','dec']
  def change_score
  end

  private

  def load_and_authorize_group
    @group = @game ? @game.group : Group.find(params[:id])
    authorize! :update, @group
  end

  def player_operation
    @game.teams.find(params[:team_id]).tap do |team|
      player = @group.players.find(params[:player_id])
      yield team, player
    end
  end

end
