class SessionsController < ApplicationController

  require 'mandrill'
  require 'pp'
  before_action :redirect_user, except: [:destroy, :google_create]

  def new
  end

  def login
  end

  def create

    @REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    input = params[:sessions][:email_username]
    if ((input =~ @REGEX) != nil ) 
       user = User.find_by(:email=> params[:sessions][:email_username].downcase)
    else
      user = User.find_by(:username => params[:sessions][:email_username])
  
    end
    if user && user.authenticate(params[:sessions][:password]) 

      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'login'
    end

  end
 # gets the tokens and displays all quests created previously
  def google_create
    auth = env["omniauth.auth"]
    if(@current_user == nil)
      user = User.find_by(:guid => auth.uid)
      if (user == nil)
        email = auth.info.email
        picture = auth.info.image
        token = auth.credentials.token
        id = auth.uid
        prov = auth.provider
        refresh_token = auth.credentials.refresh_token
        expires = auth.credentials.expires_at
        redirect_to "/signup?email=#{email}&token=#{token}&picture=#{picture}&id=#{id}&prov=#{prov}&refresh=#{refresh_token}&expires=#{expires_at}"
        return
      else
        log_in user
      end
    else
      user = User.from_omniauth(auth, @current_user)
        if @current_user.guid.blank?
          user = User.from_omniauth(auth, @current_user)
          user_quest = UsersQuest.where('assignor_id = ? OR assignee_id = ?', @current_user.id, @current_user.id).pluck(:quest_id)
          quest = Quest.where(:id => user_quest, :gid => nil)
          quest.each do |q|
            Quest.add_calendar_event q, @current_user
        end
      end
    end
    current_user
    puts "TEST #{request.env["omniauth.auth"]["credentials"]}"  
    redirect_to user_path(@current_user.id)
  end

  def register
  end
  # count the number of users that register 
  def register_user
    @user = User.new(params.require(:register).permit(:email, :password, :first_name, :last_name, :username, :gender))
    if @user.save && @user.password == params[:register][:password_confirmation]
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

  def reset_password 
  end

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
      :text => "Hi ,\r\n\r\nyou forgot your password \r\n #{domain}/users/reset_password?email=#{user.email}&token=#{token}\r\n\r\nRegards,\r\nThe team",
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
    puts "MANDRIL -------- #{sending}"
    redirect_to login_path 

  end

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
      :text => "Hi ,\r\n\r\nyour password \r\n #{password}\r\n\r\nRegards,\r\nThe team",
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
    redirect_to login_path
  end

  private
  def redirect_user
    redirect_to root_path and return if logged_in?
  end

end
