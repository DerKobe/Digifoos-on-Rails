class GroupsController < ApplicationController
  skip_authorization_check :index

  def index
    @groups = Group.where(user: current_user).order('created_at')
  end

  def show
    @group = current_group
    authorize! :read, @group

    @players = @group.players.to_a
    @games   = @group.games.order('created_at DESC').page(params[:page].to_i)
  end

end
