class SessionsController < ApplicationController
  require 'mandrill'
  before_action :redirect_user, except: [:destroy, :google_create, :google_delete, :verify_email, :send_verify]

# login an existing user view
  def login
  end

# creates a new session and logs the user in
  def create
    @REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    input = params[:sessions][:email]
    if ((input =~ @REGEX) != nil) 
       user = User.find_by(:email=> params[:sessions][:email].downcase)
    else
      user = User.find_by(:username => params[:sessions][:email])
    end

    if user && user.authenticate(params[:sessions][:password]) 
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'login'
    end
  end

# signing using Google+
  def google_create
    auth = env["omniauth.auth"]
    # User.from_omniauth(auth, @current_user)
    if(@current_user == nil)
      user = User.find_by(:guid => auth.uid)
      if (user == nil)
        email = auth.info.email
        first = auth.info.first_name
        last = auth.info.last_name
        picture = auth.info.image.gsub(/sz=\d+/, "sz=150")
        token = auth.credentials.token
        id = auth.uid
        prov = auth.provider
        refresh_token = auth.credentials.refresh_token
        expires = auth.credentials.expires_at
        redirect_to "/signup?email=#{email}&first=#{first}&last=#{last}&token=#{token}&photo=#{picture}&id=#{id}&prov=#{prov}&refresh=#{refresh_token}&expires=#{expires}"
        return
      else
        log_in user
      end
    else
      if @current_user.guid.blank?
        User.from_omniauth(auth, @current_user)
        user_quest = UsersQuest.where('assignor_id = ? OR assignee_id = ?', @current_user.id, @current_user.id).pluck(:quest_id)
        quest = Quest.where(:id => user_quest, :gid => nil)
        quest.each do |q|
          Quest.add_calendar_event q, @current_user
        end
      end
    end
    current_user
    redirect_to root_path
  end

  def google_delete
    user_quest = UsersQuest.where('assignor_id = ? OR assignee_id = ?', @current_user.id, @current_user.id).pluck(:quest_id)
    quest = Quest.where(:id => user_quest).where.not(:gid => nil)
    quest.each do |q|
      Quest.delete_calendar_event q, @current_user
    end
    @current_user.oauth_token = params[:token]
    @current_user.provider = params[:prov]
    @current_user.guid =params[:id]
    @current_user.oauth_refresh_token = params[:refresh]
    @current_user.oauth_expires_at = Time.at(params[:expires].to_i)
    @current_user.photo = params[:photo]
    @current_user.save
    redirect_to user_path(@current_user.id)
  end

# register a new user view
  def register
  end

  # regsiters the user and publishes the count of newly registered users
  def register_user
    @user = User.new(params.require(:register).permit(:email, :password, :first_name, :last_name, :username, :gender))
    if !params[:token].nil?
      @user.oauth_token = params[:token]
      @user.provider = params[:prov]
      @user.guid =params[:id]
      @user.oauth_refresh_token = params[:refresh]
      @user.oauth_expires_at = Time.at(params[:expires].to_i)
      @user.photo = params[:photo]
    end
    if @user.save && @user.password == params[:register][:password_confirmation]
      log_in @user
      User.publish_event :sign_ups, ({:sign_ups => 'Number of Users'})
      token = Token.generate_random
      Token.create(:key => token, :user_id => @user.id, :token_type => 'verify')
      domain = 'http://localhost:3000'
      m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
      message = {
        :subject=> "[QuestBoard] Email Verification",
        :from_name=> "QuestBoard",
        :text => "Hi #{@user.first_name},\r\n\r\nThank you for choosing QuestBoard. Please click on the link below to verify your email.\r\n\r\n#{domain}/verify_email?email=#{@user.email}&token=#{token}\r\n\r\nRegards,\r\nThe team",
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
      flash[:success] = []
      flash[:success] << "Your account has been successfully created."
      redirect_to root_path
    else
      render 'register'
    end
  end

  def send_verify
    token = Token.generate_random
    Token.create(:key => token, :user_id => @current_user.id, :token_type => 'verify')
    domain = 'http://localhost:3000'
    m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
    message = {
      :subject=> "[QuestBoard] Email Verification",
      :from_name=> "QuestBoard",
      :text => "Hi #{@current_user.first_name},\r\n\r\nThank you for choosing QuestBoard. Please click on the link below to verify your email.\r\n\r\n#{domain}/verify_email?email=#{@current_user.email}&token=#{token}\r\n\r\nRegards,\r\nThe team",
      :to=>[
        {
          :email=> "#{@current_user.email}",
          :type=>"to",
          :name=> "#{@current_user.first_name}"
        }
      ],
      :from_email=>"team@questboard.com"
    }
    sending = m.messages.send message
    flash[:success] = []
    flash[:success] << "Verification email was sent."
    redirect_to user_path(@current_user.id)
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
    # flash[:success] = "Your email has been successfully verified."
    flash[:success] = []
    flash[:success] << "Your email has been successfully verified."
    flash.keep
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path
  end

# reset user's password view
  def reset_password 
  end

  #sends an email to the user and verfies the email
  def forgot_password
     m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
     user = User.find_by(:email => params[:sessions][:email])
     redirect_to login_path and return if user.nil? 
     domain = "http://localhost:3000"
     token = Token.generate_random
     Token.create(:user_id => user.id, :token_type => 'password', :key => token)
    
    message = {
      :subject=> "[QuestBoard] Reset Password",
      :from_name=> "QuestBoard",
      :text => "Hi,\r\n\r\nYou requested to reset your password. Click on the link below to receive your new password\r\n #{domain}/reset_password?email=#{user.email}&token=#{token}\r\n\r\nIf it wasn't you, please disregard this email.\r\n\r\nRegards,\r\nThe team",
      :to=>[
        {
          :email=> "#{params[:sessions][:email]}",
          :type=>"to",
          :name=> "#{user.first_name}"   
        }
      ],
      :from_email=>"team@questboard.com"
    }
    sending = m.messages.send message
    flash[:info] = []
    flash[:info] << "Please follow the email sent to you to reset your password."
    redirect_to login_path 
  end

  #sends a new password to the user
  def send_password
    m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
    email = params[:email]
    key = params[:token]
    token = Token.find_by(:key => key)
    user = User.find_by(:email => email)
    if !token.nil? && !user.nil? && user.id == token.user_id
      domain = "http://localhost:3000"
      password = Token.generate_random 8
      user.password=password
      user.save
       message = {
      :subject=> "[QuestBoard] Password",
      :from_name=> "QuestBoard",
      :text => "Hi ,\r\n\r\nYour new password is:\r\n #{password}\r\n\r\nYour old password is no longer valid.\r\n\r\nRegards,\r\nThe team",
      :to=>[
        {
          :email=> "#{user.email}",
          :type=>"to",
          :name=> "#{user.first_name}"   
        }
      ],
      :from_email=>"team@questboard.com"
    }
    sending = m.messages.send message
    Token.delete(token.id)
    Token.where(:user_id => user.id, :token_type => "access").delete_all
    end
    flash[:success] = []
    flash[:success] << "Your password has been successfully reset and was sent to your email."
    redirect_to login_path
  end

  private
  def redirect_user
    redirect_to root_path and return if logged_in?
  end
end
