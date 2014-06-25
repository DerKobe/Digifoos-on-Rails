class GroupsController < ApplicationController
  skip_authorization_check :index

  def index
    @groups = Group.where(user: current_user).order('created_at')
  end

  def show
    @group = current_group
    authorize! :read, @group

    @players      = PlayersService.get_players_for(@group)
    @games        = @group.games.order('created_at DESC').page(params[:page].to_i)
    @current_game = @group.games.last
  end

end
