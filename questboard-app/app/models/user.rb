class User < ActiveRecord::Base

	before_save { self.email = email.downcase if not self.email.blank?}

	validates :first_name, presence: true, length: { maximum: 50 }
	validates :last_name, presence: true, length: { maximum: 50 }
	validates :user_name, presence:true, uniqueness: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  	validates :password, length: { minimum: 6 }, :on => :create

  	# validates :gender, :in => %w( m f )

	has_many :tasks, foreign_key: "user_id"

	has_secure_password validations: false
		
end
