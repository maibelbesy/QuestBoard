class User < ActiveRecord::Base

  before_save { self.email = email.downcase if not self.email.blank?}

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 30 }
  validates :username, presence:true, uniqueness: true, length: { maximum: 10 }

  require 'net/http'
  require 'json'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

	validates :password, length: { minimum: 6 }, :on => :create
	validates_confirmation_of :password, length: { minimum: 6 }
  has_many :tasks, foreign_key: "user_id"
  has_many :notifications
  has_secure_password validations: false
  


  def self.unread_notifications_count(user)
  	Notification.where(:user_id => user.id, :is_seen => false).count
  end

  def self.from_omniauth(auth, users)

    user = self.find_by_id(users.id)
    user.provider = auth.provider
    user.guid = auth.uid
    user.oauth_token = auth.credentials.token
    user.oauth_refresh_token = auth.credentials.refresh_token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!

    self.check_for_quests(user)
  end

  require 'pp'

  def self.check_for_quests(user)
    client = Google::APIClient.new
    client.authorization.access_token = user.fresh_token
    service = client.discovered_api('gmail')
    result = client.execute(
      :api_method => service.users.messages.list,
      :parameters => {'userId' => 'me', :q => 'subject:' + '[QuestBoard] Task Assignment'},
      # :parameters => {'userId' => 'me', 'id' => '14c996b88e06a615'},
      :headers => {'Content-Type' => 'application/json'})
    data = JSON.parse(result.body)
    messages = data['messages']
    messages.each do |message|
      self.assign_quest user, message["id"]
      # pp message[:id]
    end
  end

  def self.assign_quest (user, message)
    client = Google::APIClient.new
    client.authorization.access_token = user.fresh_token
    service = client.discovered_api('gmail')
    result = client.execute(
      :api_method => service.users.messages.get,
      :parameters => {'userId' => 'me', 'id' => "#{message}", 'format' => 'minimal'},
      :headers => {'Content-Type' => 'application/json'})
    data = JSON.parse(result.body)
    quest_id = data['snippet'].scan(/\[\quest \d+\]/)[0].scan(/\d+/)[0].to_i

    user_quest = UsersQuest.find_by(:quest_id => quest_id, :assignee_id => nil)
    if user_quest != nil
      user_quest.assignee_id = user.id
      user_quest.save
    end

    # pp data
    # pp data['snippet'].scan(/\[\quest #\d+\]/)[0].scan(/\d+/)[0]
    # if data['payload']['mimeType'].split('/')[0] == 'multipart'
    #   pp Base64.decode64 data['payload']['parts'][0]['body']['data']  
    # else
    #   pp Base64.decode64 data['payload']['body']['data']
    # end
  end
 
   def to_params

    {'refresh_token' => oauth_refresh_token,
      'client_id' => ENV['CLIENT_ID'],
      'client_secret' => ENV['CLIENT_SECRET'],
      'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    response = request_token_from_google
    data = JSON.parse(response.body)
    update_attributes(
    oauth_token: data['access_token'],
    oauth_expires_at: Time.now + (data['expires_in'].to_i).seconds)
  end

  def expired?
    oauth_expires_at < Time.now
  end

  def fresh_token
    refresh! if expired?
    oauth_token
  end

  def google_connected?
    guid.blank?
  end

end
