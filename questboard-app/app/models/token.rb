class Token <ActiveRecord::Base
	require 'securerandom'
	def self.generate_random length=32
		SecureRandom.urlsafe_base64(length).to_s
	end
end