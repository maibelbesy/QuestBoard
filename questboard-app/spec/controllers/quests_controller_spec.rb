require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
	
	it "Assign Quest to User" do
		
		quest = Quest.create( :title => "Test Quest" , :description => "Quest in RSPEC to test Quests Controller")
		userquest =UsersQuest.create(:assignor_id => "1", :assignee_id => "2", :quest_id => quest.id)
		put :create
		expect(userquest.assignee_id).to eq 2
	end

	it "Add Review on a completed Ques" do
		quest = Quest.create( :title => "Test Quest's Review" , :description => "Quest in RSPEC to test the Review")
		userquest =UsersQuest.create(:assignor_id => "1", :assignee_id => "3", :quest_id => quest.id )
		quest.is_completed = true
		put :add_review, id: quest.id
		userquest.update( :review => "Test Quest was great")
		expect(userquest.review).to eq "Test Quest was great"
	end

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
end
