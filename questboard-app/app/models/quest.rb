class Quest < ActiveRecord::Base
	has_many :tasks, foreign_key: "quest_id", dependent: :destroy

	def self.create_personal_quest(args, user)
		quest = self.create(args)
		UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
	end
	require 'net/smtp'
def send_email(to,opts={})
  opts[:server]      ||= 'localhost'
  opts[:from]        ||= 'email@example.com'
  opts[:from_alias]  ||= 'Example Emailer'
  opts[:subject]     ||= "You have to complete your task"
  opts[:body]        ||= "Important stuff!"

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
 end
 def reminder 
 	@quests=Quest.all
    @quests.each do |q|
    if (q.remind_to == true && DateTime.now == q.reminder)
   	send_email q.email, :body => "please finish your task asap"
    q.remind_to=false
   end 
 end
end
end