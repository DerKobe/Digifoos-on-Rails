class PlayersController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    authorize! :read, current_group

    @players = current_group.players.order('name')
  end

  def show
  end

end
