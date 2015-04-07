class SessionsController < ApplicationController
  before_action :redirect_user, except: [:destroy, :google_create]

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
    #@auth = request.env["omniauth.auth"]
    #Use the token from the data to request a list of calendars
    #@token = @auth["credentials"]["token"]
    #client = Google::APIClient.new
    #client.authorization.access_token = @token
    #service = client.discovered_api('calendar', 'v3')
    #@result = client.execute(
     # :api_method => service.calendar_list.list,
      #:parameters => {},
      #:headers => {'Content-Type' => 'application/json'})
    puts "TEST #{request.env["omniauth.auth"]["credentials"]}"  

    redirect_to user_path(@current_user.id)
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
