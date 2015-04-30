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
 # gets the tokens and displays all quests created previously
  def google_create
    auth = env["omniauth.auth"]
    puts "HASH ---------------- #{auth}"
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
