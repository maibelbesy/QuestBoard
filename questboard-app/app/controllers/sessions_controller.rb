class SessionsController < ApplicationController
  require 'mandrill'
  before_action :redirect_user, except: [:destroy, :google_create, :verify_email]

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
      token = Token.generate_random
      Token.create(:key => token, :user_id => @user.id, :token_type => 'verify')
      domain = 'http://localhost:3000'
      m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
      message = {
        :subject=> "[QuestBoard] Email Verification",
        :from_name=> "QuestBoard",
        :text => "Hi #{@user.first_name},\r\n\r\nThank you for choosing QuestBoard. Please click on the link below to verify your email.\r\n\r\n#{domain}/users/verify_email?email=#{@user.email}&token=#{token}\r\n\r\nRegards,\r\nThe team",
        :to=>[
          {
            :email=> "#{@user.email}",
            :type=>"to",
            :name=> "#{@user.first_name}"
          }
        ],
        :from_email=>"team@questboard.com"
      }
      sending = m.messages.send message
      puts sending
      redirect_to root_path
    else
      render 'register'
    end
  end

  def verify_email
    email = params[:email]
    key = params[:token]

    user = User.find_by(:email => email)
    token = Token.find_by(:key => key)

    if !token.nil? && !user.nil? && user.id == token.user_id
      user.email_verified = true
      user.save
      Token.delete(token.id)
    end
    redirect_to root_path
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
