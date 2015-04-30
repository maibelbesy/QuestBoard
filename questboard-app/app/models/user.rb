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

    puts "AUTH------------#{auth.info.email}"
    puts "AUTH------------#{auth}"
    puts "AUTH------------#{auth.credentials}"

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
    return if messages == nil
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
  # setting keen api key and then publish the analytics event
  def self.publish_event col, hash
    keen = Keen::Client.new(:project_id => '553e50d296773d66ebe3d8a1',
                        :write_key  => '0c94a97409a33626937e8068934a664b60d136e0531bcb56f3b14e1d83dfe1235ace7cbda2dc5a4e3882a0a25a0b621626909536884b894fa860599420c22ecdcd09a8921aa777217aa46d1432a676c11c14cd2e53c12997c3cde78147e17640d1295ea17002c55a10f631075ed9af05',
                        :read_key   => '04b1c1d473ea426c9bbdeed886b7dcf5a22efc9a9263a5a79159d3f0791087a6a406a44bf78d88f6a1742d7838d96ea311552dac3cc3edbd17107cc2b7c94b7d58e5c38e9a8f9a610cbae54cfc051c7ea5746ea47d29141146285acf19f6b6c28d33e40e9b84eb2c04da0ead1084e62d',
                        :master_key => 'CDCE3F5F71725B60AFAD7A6A5262D6DF')

    keen.publish(col, hash)
  end

end
