class Quest < ActiveRecord::Base
  require 'mandrill'
  require 'pp'

  has_many :tasks, foreign_key: "quest_id", dependent: :destroy
  has_many :quest_images, :dependent => :destroy
  accepts_nested_attributes_for :quest_images, :reject_if => lambda { |t| t['quest_image'].nil? }

  has_many :quest_videos , :dependent => :destroy

  def self.create_general_quest(args, user, reminderD)
    if args[:assign_to].blank?
      args.delete :assign_to
      quest = self.create(args.except :remind_to)
      UsersQuest.create(:assignor_id => user.id, :assignee_id=>user.id, :quest_id => quest.id, :is_accepted => true)
    else
      quest = self.create(args.except(:assign_to, :remind_to))
      # id = User.find_by(:username => args[:assign_to]).id
      users = User.find_by(:username => args[:assign_to])
      id = users.id if users != nil
      UsersQuest.create(:assignor_id => user.id, :assignee_id=>id, :quest_id => quest.id)
    end
    if (args[:remind_to] == 'true')
         Reminder.create(:user_id=>user.id, :quest_id=> quest.id,:reminder=> self.date_convert(reminderD))
    else
      due_date= Quest.find_by_id(quest.id).pluck(:due_date)
      date=due_date.to_date()
      ##due_date.strftime("%d-%m-%Y") - DateTime.now.strftime("%d-%m-%Y") > 1.days
      if(due_date.to_date()- Date.now > 1.day)
        Reminder.create(:user_id=>user.id, :quest_id=> quest.id,:reminder=> due_date)
      end
    end
    if not user.google_connected?
      self.add_calendar_event quest, user
    end
    quest
  end

  def self.assign_non_user(assignor, quest, assignee)
    m = Mandrill::API.new 'BCyRB5oNxOdZCcjMqpzpzA'
    message = {
      :subject=> "[QuestBoard] Task Assignment",
      :from_name=> "QuestBoard",
      :text => "Hi #{assignee},\r\n\r\n#{assignor.first_name} #{assignor.last_name} assigned you a [quest #{quest.id}] on QuestBoard\r\ntitle: #{quest.title}\r\ndescription: #{quest.description}\r\ndue date: #{quest.due_date}\r\n\r\nTo view this quest, register for QuestBoard at http://localhost:3000/signup and connect your account with Google+.\r\n\r\nRegards,\r\nThe team",
      :to=>[
        {
          :email=> "#{assignee}",
          :type=>"to",
          :name=> "#{assignee}"
        }
      ],
      :from_email=>"team@questboard.com"
    }
    sending = m.messages.send message
  end


  def self.date_convert (reminderD)
    DateTime.new(reminderD["reminder(1i)"].to_i,
                 reminderD["reminder(2i)"].to_i,
                 reminderD["reminder(3i)"].to_i,
                 reminderD["reminder(4i)"].to_i,
                 reminderD["reminder(5i)"].to_i)
  end

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
          :subject=> "[QuestBoard] Reminder",
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
          :from_email=>"reminders@questboard.com"
        }
        sending = m.messages.send message
        puts sending
        r.delete

      end
    end
  end

  def self.add_demo
    Quest.create(:title => "reminder")
  end

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
    quest.gid = data["id"]
    quest.save
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
    event.summary = quest.title
    event.start.date = quest.due_date.to_date.to_s
    event.end.date = quest.due_date.to_date.to_s

    result = client.execute(:api_method => service.events.update,
                            :parameters => {'calendarId' => 'primary', 'eventId' => quest.gid},
                            :body_object => event,
                            :headers => {'Content-Type' => 'application/json'})

  end
end


