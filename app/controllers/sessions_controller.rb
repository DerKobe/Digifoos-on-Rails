class SessionsController < ApplicationController
  skip_authorization_check only: :index
  load_and_authorize_resource

  def index
    @sessions = Session.where(user: current_user).order('name')
  end

  def show
  end

end
