class ApplicationController < ActionController::Base
  before_action :authorize_user
  
  include SessionsHelper
  include UsersHelper
  protect_from_forgery with: :exception

  #redirects the user to the login page if he isnt logged in
  private
  def authorize_user
    exemptions = ['/login', '/signup', '/auth/google_oauth2/callback', '/reset_password',
      '/forgot_password', '/users/reset_password','/users/verify_email']
    redirect_to login_path and return if !logged_in? && (!exemptions.include? request.path)
    current_user
  end
end
 
