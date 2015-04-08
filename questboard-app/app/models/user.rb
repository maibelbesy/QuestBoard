class User < ActiveRecord::Base
  before_save { self.email = email.downcase if not self.email.blank?}

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 30 }
  validates :username, presence:true, uniqueness: true, length: { maximum: 10 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

	validates :password, length: { minimum: 6 }, :on => :create

  validates_confirmation_of :password, length: { minimum: 6 }

  has_many :tasks, foreign_key: "user_id"

  has_secure_password validations: false

  def self.from_omniauth(auth, users)

    user = self.find_by_id(users.id)
    user.provider = auth.provider
    user.guid = auth.uid
    user.oauth_token = auth.credentials.token
    user.oauth_refresh_token = auth.credentials.refresh_token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!
  end

  require 'net/http'
  require 'json'

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
