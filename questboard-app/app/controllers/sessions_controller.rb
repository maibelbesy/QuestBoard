class SessionsController < ApplicationController

  before_action :redirect_user, except: [:destroy, :google_create]

  def new
  end

  def login
  end

  def create
    user = User.find_by(:email => params[:sessions][:email].downcase)
    if user && user.authenticate(params[:sessions][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'login'
    end

  end

  def google_create
    user = User.from_omniauth(env["omniauth.auth"], @current_user)
    puts "TEST #{request.env["omniauth.auth"]["credentials"]}"  
    redirect_to user_path(@current_user.id)
  end

  def register
  end
  # count the number of users that register 
  def register_user
    @user = User.new(params.require(:register).permit(:email, :password, :first_name, :last_name, :username, :gender))
    if @user.save
      log_in @user
      User.publish_event :sign_ups, ({:sign_ups => 'Number of Users'})
      redirect_to root_path
    else
      render 'register'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def redirect_user
    redirect_to root_path and return if logged_in?
  end
end
