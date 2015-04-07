class Quest < ActiveRecord::Base
  has_many :tasks, foreign_key: "quest_id", dependent: :destroy
  include UsersHelper
  def self.create_personal_quest(args, user , reminderD)
    quest = self.create(args)
    UsersQuest.create(:assignor_id => user.id, :assignee_id => user.id, :quest_id => quest.id)
    if (quest.remind_to==true)
      Reminder.create(:user_id=>user.id, :quest_id=> quest.id, :reminder=> self.date_convert(reminderD))
    end
    if not user.google_connected?
    self.add_calendar_event quest, user
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

  require 'pp'

  def self.add_calendar_event (quest, user)
    client = Google::APIClient.new
    client.authorization.access_token = user.fresh_token
    service = client.discovered_api('calendar', 'v3')
    event = {'summary' => quest.title,'start' => {'date' => "#{quest.due_date.to_date}"},'end' => {'date' => "#{quest.due_date.to_date}"}}
    result = client.execute(:api_method => service.events.insert,
    :parameters => {'calendarId' => 'primary'},
    :body => JSON.dump(event),
    :headers => {'Content-Type' => 'application/json'})
    data = JSON.parse(result.body)
    pp quest.due_date.to_date
    quest.gid = data["id"]
    quest.save
    pp data
  end

  def self.delete_calendar_event (quest, user)
    client = Google::APIClient.new
    client.authorization.access_token = user.fresh_token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(:api_method => service.events.delete,
    :parameters => {'calendarId' => 'primary', 'eventId' => quest.gid})
  end

  def self.update_calendar_event (quest, user)
    client = Google::APIClient.new
    client.authorization.access_token = user.fresh_token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(:api_method => service.events.get,
    :parameters => {'calendarId' => 'primary', 'eventId' => quest.gid})
    event = result.data
    pp "TEST #{event.start.date}"
    event.summary = quest.title
    event.start.date = quest.due_date.to_date.to_s
    event.end.date = quest.due_date.to_date.to_s

    result = client.execute(:api_method => service.events.update,
    :parameters => {'calendarId' => 'primary', 'eventId' => quest.gid},
    :body_object => event,
    :headers => {'Content-Type' => 'application/json'})

  end
end

