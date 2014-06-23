class ApplicationController < ActionController::Base
  # extends ....................................................................
  # includes ...................................................................
  # constants ..................................................................
  # filters ....................................................................
  before_filter :current_group

  # helpers ....................................................................
  # scopes .....................................................................
  # additional config ..........................................................

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied, :with => :forbidden
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  # controller actions .........................................................
  # protected instance methods .................................................

  protected

  def forbidden
    set_meta_tags :title => 'Forbidden'
    render :forbidden, :status => :forbidden
  end

  def not_found
    set_meta_tags :title => 'Not found'
    render :not_found, :status => :not_found
  end

  private

  def current_group
    @current_group ||= begin
      if params[:group_id].present? || (params[:controller] == 'groups' && params[:id].present?)
        Group.find params[:group_id] || params[:id]
      end
    end
  end
end
