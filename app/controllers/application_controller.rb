class ApplicationController < ActionController::Base
  before_filter :current_group
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied, :with => :forbidden
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  protected

  def forbidden
    set_meta_tags :title => 'Forbidden'
    render :forbidden, :status => :forbidden
  end

  def not_found
    set_meta_tags :title => 'Not found'
    render :not_found, :status => :not_found
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :email
  end

  def current_group
    @group ||= begin
      if params[:group_id].present? || (params[:controller] == 'groups' && params[:id].present?)
        Group.find params[:group_id] || params[:id]
      end
    end
  end
end
