class PlayersController < ApplicationController
  load_and_authorize_resource except: :index

  before_filter :current_group

  def index
    authorize! :update, @group

    @players = @group.players.order('name')
  end

  def new
    authorize! :update, @group
    @player = Player.new group: @group
  end


  def create
    authorize! :update, @group

    @player = Player.create player_params

    if @player.persisted?
      redirect_to group_players_path(@group)
    else
      render :new
    end
  end

  def edit
    authorize! :update, @group

    @player = @group.players.find(params[:id])
  end

  def update
    authorize! :update, @group

    @player = @group.players.find(params[:id])

    if @player.update(player_params)
      redirect_to group_players_path(@group)
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @group

    flash = {}

    if PlayersService.played_already? params[:id]
      flash[:alert] = 'The player can\'t be deleted because he/she already played a game.'
    else
      @group.players.find(params[:id]).destroy
    end

    redirect_to group_players_path(@group), flash
  end

  private

  def player_params
    params.require(:player).permit(:name).merge group: @group
  end

end
