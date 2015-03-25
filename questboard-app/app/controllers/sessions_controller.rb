class SessionsController < ApplicationController
  before_action :redirect_user, except: [:destroy]

  def new
  end

  def create
  	user = User.find_by(:email => params[:sessions][:email].downcase)
   	if user && user.authenticate(params[:sessions][:password])
     log_in user
     redirect_to root_path
  	 else
     flash.now[:danger] = 'Invalid email/password combination'
     render 'new'
  	end
  end


  def register
  end

  def register_user
    @user = User.new(params.require(:register).permit(:email, :password, :first_name, :last_name, :username, :gender))
    if @user.save
      log_in @user
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
