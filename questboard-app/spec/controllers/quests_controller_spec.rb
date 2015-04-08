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

	 
end
