class GroupsController < ApplicationController
  skip_authorization_check :index

  def index
    @groups = Group.where(user: current_user).order('created_at')
  end

  def show
    @group = current_group
    authorize! :read, @group

    @games   = @group.games.includes(:teams, :players).where(status: Game.statuses[:finished]).order('created_at DESC').page(params[:page].to_i).per(15)
    @players = PlayersService.get_players_for(@group)
    @game    = @group.games.includes(:teams, :players).where(status: [Game.statuses[:created], Game.statuses[:running]]).first
  end

end