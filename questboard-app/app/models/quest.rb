class Quest < ActiveRecord::Base
  has_many :tasks, foreign_key: "quest_id", dependent: :destroy

  def self.create_personal_quest(args, user , reminderD)
    quest = self.create(args)
    UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
    if (quest.remind_to==true)
    Reminder.create(:user_id=>user.id, :quest_id=> quest.id, :reminder=> self.date_convert(reminderD))
end
  end

  def self.date_convert (reminderD)
    DateTime.new(reminderD["reminder(1i)"].to_i, 
                        reminderD["reminder(2i)"].to_i,
                        reminderD["reminder(3i)"].to_i,
                        reminderD["reminder(4i)"].to_i,
                        reminderD["reminder(5i)"].to_i)
  end

  require 'mandrill'
  def self.reminders 
    @reminders_all = Reminder.all
    date = DateTime.now.utc.strftime("%d-%m-%Y %H:%M")
    @reminders_all.each do |r|
      if (date == r.reminder.utc.strftime("%d-%m-%Y %H:%M"))
        @quest = Quest.find(r.quest_id)
        @user = User.find(r.user_id)
        @quest.remind_to = false
        @quest.save
        m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
        message = {  
          :subject=> "Quest Reminder",  
          :from_name=> "QuestBoard",  
          :text=>"Hello",  
          :to=>[  
            {  
            :email=> "#{@user.email}", 
            :type=>"to", 
            :name=> "#{@user.first_name} #{@user.last_name}" 
            }  
          ],  
          :html=>"<html><h1>Hi, #{@quest.title} deadline is on <strong>#{@quest.due_date.strftime("%d-%m-%Y %H:%M")} </strong></h1></html>",
          :from_email=>"QuestBoard@yourdomain.com"  
        }  

        sending = m.messages.send message  
        puts sending
       r.delete
      end 
    end
  end

 end

