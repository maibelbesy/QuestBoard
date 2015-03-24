class SessionsController < ApplicationController
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
    hash = params[:register]
    gender = true if hash[:male] == "1"
    gender = false if hash[:female] == "1"
    @user = User.new(:email => hash[:email], :first_name => hash[:first_name], :password => hash[:password], :last_name => hash[:last_name], :username => hash[:username], :gender => gender)
    # @user = User.new(hash.require(:quest).permit(:email, :first_name, :last_name, :username, :gender))
    if @user.save
      log_in @user
      redirect_to root_path
    else
      render 'register'
    end
  end


  def destroy
  	log_out
    redirect_to root_url
  end
end
