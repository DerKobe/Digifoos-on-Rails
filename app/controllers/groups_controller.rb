class GroupsController < ApplicationController
  skip_authorization_check :index

  before_filter :current_group, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to :root unless user_signed_in?

    @groups = Group.where(user: current_user).order('created_at')
  end

  def show
    authorize! :read, @group

    @games   = @group.games.includes(:teams, :players).where(status: Game.statuses[:finished]).order('created_at DESC').page(params[:page].to_i).per(15)
    @players = PlayersService.get_players_for(@group)
    @game    = @group.games.includes(:teams, :players).where(status: [Game.statuses[:created], Game.statuses[:running]]).first
  end

  def new
    authorize! :create, Group
    @group = current_user.groups.new
  end

  def create
    authorize! :create, Group

    @group = Group.create group_params

    if @group.persisted?
      redirect_to group_players_path(@group)
    else
      render :new
    end
  end

  def edit
    authorize! :update, @group
  end

  def update
    authorize! :update, @group

    if @group.update group_params
      redirect_to group_path(@group)
    end
  end

  def destroy
    authorize! :destroy, @group
    if @group.destroy
      redirect_to :root
    else
      flash[:alert] = 'Something went wrong!'
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).permit(:name).merge user: current_user
  end

end