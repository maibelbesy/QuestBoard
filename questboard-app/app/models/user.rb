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

	# validates :gender, :in => %w( m f )

	has_many :tasks, foreign_key: "user_id"
	has_many :notifications

  has_secure_password validations: false

  def self.unread_notifications_count(user)
  	Notification.where(:user_id => user.id, :is_seen => false).count
  end
end
