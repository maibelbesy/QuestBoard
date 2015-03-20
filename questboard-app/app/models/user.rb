class User < ActiveRecord::Base

  # DO NOT ALTER ANYTHING BELOW THIS LINE

  before_save { self.email = email.downcase if not self.email.blank?}

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, :on => :create

  has_many :posts, foreign_key: "user_id"
  has_many :comments, foreign_key: "user_id"

  has_secure_password validations: false
  
  has_attached_file :photo, :styles => { :small => "150x150>" }, :default_url => "",
                  :url  => "/assets/posts/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/posts/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  
end
