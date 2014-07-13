class GamesController < ApplicationController
  load_resource except: [:create, :destroy_last_game]
  before_filter :load_and_authorize_group

  # POST /groups/:group_id/games
  def create
    begin
      @game = @group.games.create!
      @game.teams.create!
      @game.teams.create!
    rescue => e
      Rails.logger.error e
      @game = GamesService.open_game_for @group
    end

    render 'open_game'
  end

  # DELETE /games/:group_id/games
  def destroy_last_game
    @group.games.order('created_at DESC').limit(1).first.destroy!
    redirect_to "/#{@group.slug}"
  end

  # POST /games/:id/start
  def start
    @game.start!
    render 'open_game'
  end

  # POST /games/:id/canel
  def cancel
    @game.destroy!
    @game = nil
    render 'open_game'
  end

  # POST /games/:id/finish
  def finish
    GamesService.finish_game @game if @game.finishable?
    redirect_to @group
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

    render 'open_game'
  end

  # POST /games/:id/teams/:team_id
  def inc_goals
    GamesService.inc_goals params[:team_id]
    render 'open_game'
  end

  # DELETE /games/:id/teams/:team_id
  def dec_goals
    GamesService.dec_goals params[:team_id]
    render 'open_game'
  end

  private

  def load_and_authorize_group
    @group = @game ? @game.group : Group.find(params[:id])
    authorize! :manage_games, @group
  end

  def player_operation
    @game.teams.find(params[:team_id]).tap do |team|
      player = @group.players.find(params[:player_id])
      yield team, player
    end
  end

end
