class ManagersController < ApplicationController
  before_filter :load_and_authorize_group

  def add
    user = User.find params[:user_id]
    @group.users << user unless @group.users.include? user

    render 'managers/update_lists'
  end

  def remove
    user = User.find params[:user_id]
    @group.users.delete user if @group.users.include? user

    render 'managers/update_lists'
  end

  private

  def load_and_authorize_group
    @group = Group.find(params[:id])
    authorize! :update, @group
  end

end
