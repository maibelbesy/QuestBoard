class Quest < ActiveRecord::Base
	has_many :tasks, foreign_key: "quest_id", dependent: :destroy

	def self.create_personal_quest(args, user)
		quest = self.create(args)
		UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
	end

#require 'net/smtp'
#def send_email(to,opts={})
 # opts[:server]      ||= 'localhost'
  #opts[:from]        ||= 'email@example.com'
  #opts[:from_alias]  ||= 'Example Emailer'
  #opts[:subject]     ||= "You have to complete your task"
  #opts[:body]        ||= "Important stuff!"

  #msg = <<END_OF_MESSAGE
#From: #{opts[:from_alias]} <#{opts[:from]}>
#To: <#{to}>
#Subject: #{opts[:subject]}

#{opts[:body]}
#END_OF_MESSAGE

 # Net::SMTP.start(opts[:server]) do |smtp|
  #  smtp.send_message msg, opts[:from], to
  #end
 #end
 require 'mandrill' 
 def self.reminders 
    @quests=Quest.all
    @quests.each do |q|
    ##@Quest=UsersQuest.find_by_quest_id(q.id)
    @userQuest=UsersQuest.where(:quest_id => q.id).pluck(:assignee_id)
    @user=User.find(userQuest)
    if (q.remind_to == true && DateTime.strftime("%d-%m-%Y %H:%M") == q.reminder..strftime("%d-%m-%Y %H:%M"))
     q.remind_to=false
      m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
      message = {  
      :subject=> "Hello from the Mandrill API11",  
      :from_name=> "QuestBoard",  
      :text=>"Hello",  
      :to=>[  
      {  
      :email=> "nesreen.mouti@gmail.com", 
      :type=>"to", 
      :name=> @user.first_name 
      }  
    ],  
      :html=>"<html><h1>Hi #{q.title} deadline is on<strong>#{q.due_date} </strong></h1></html>",  
      :from_email=>"QuestBoard@yourdomain.com"  
  }  

      sending = m.messages.send message  
      puts sending
    #send_email #@user.email, :body => "please finish your task asap"
     end 
   end
  end

 end
