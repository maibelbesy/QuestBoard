require 'rails_helper'

RSpec.describe Quest, type: :model do

it "Reminds User of Quest's Deadline" do
		user = User.create(:email => "nesreen.mouti@gmail.com", :username => "NM", :first_name=> "Nesreen", :last_name => "Mamdouh", :password => "123456" )
		quest = Quest.create( :title => "Test Quest Reminder" , :description => "Remind me ")
		if quest.remind_to ==true
			reminder = Reminder.create(:user_id => "1", :quest_id => quest.id , :reminder => "02/02/2015")
			put :reminders
			user.email.should_not be_nil
			user.first_name.should_not be_nil
			quest.title.should_not be_nil
			quest.due_date.should_not be_nil
			
		end
	end
it "Delete event from Calendar" do
	quest = Quest.create( :title => "Test Quest Reminder" , :description => "Remind me ")
	put :destroy 
	quest.gid.should be_nil

end
	
it "Add event to Calendar" do
quest = Quest.create( :title => "Test Quest Reminder" , :description => "Remind me ")
quest.guid.should_not be_nil
	
end
end
