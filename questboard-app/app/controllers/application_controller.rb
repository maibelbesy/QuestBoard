class ApplicationController < ActionController::Base
  before_action :authorize_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include SessionsHelper
  include UsersHelper
  protect_from_forgery with: :exception

  private
  def authorize_user
    puts "PATH -------- #{request.path}"
     redirect_to login_path and return if !logged_in? && (request.path != "/login" && request.path != "/signup" && request.path != "/auth/google_oauth2/callback")
    current_user
  end
end
