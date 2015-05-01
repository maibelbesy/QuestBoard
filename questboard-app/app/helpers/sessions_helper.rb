module SessionsHelper
  require 'securerandom'

  def log_in(user)
    # session[:user_id] = user.id
    acces_token = generate_random
    Token.create(:key => acces_token, :user_id => user.id)
    cookies[:acces_token] = acces_token
  end

  def current_user
    # if (user_id = session[:user_id])
    #   @current_user ||= User.find_by(id: session[:user_id])
    # elsif (user_id = cookies.signed[:user_id])
    #   user = User.find_by(id: user_id)
    #   if user && user.authenticated?(cookies[:remember_token])
    #     log_in user
    #     @current_user = user
    #   end
    # end
    token = Token.find_by(:key => cookies[:acces_token])
    @current_user ||= User.find_by(:id => token.user_id) if !token.nil?
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    # session.delete(:user_id)
    Token.delete_all(:key => cookies[:acces_token])
    cookies.delete :acces_token
    @current_user = nil
  end

  private
  def generate_random length=32
    SecureRandom.urlsafe_base64(length).to_s
  end
end
