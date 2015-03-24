class ApplicationController < ActionController::Base
	before_action :authorize_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  protect_from_forgery with: :exception

private
  def authorize_user
  	redirect_to login_path and return if !logged_in? && (request.path != "/login" && request.path != "/signup")
  	current_user
  end
end
