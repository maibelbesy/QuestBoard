class SessionsController < ApplicationController
  def new
  end

 def create
  	user = User.find_by(email: params[:session][:email].downcase)
   	if user && user.authenticate(params[:session][:password])
     log_in user
     redirect_to user
  	 else
     flash.now[:danger] = 'Invalid email/password combination'
     render 'new'
  	end
 end

 def register
    hash = params[:register]
    @user = User.new(:email => hash[:email], :name => hash[:name], :password => hash[:password])
    if @user.save
      log_in @user
      redirect_to posts_path
    else
      render 'register'
    end
  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
