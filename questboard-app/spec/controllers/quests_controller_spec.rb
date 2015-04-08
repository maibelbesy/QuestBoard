require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
	describe QuestsController do
		it "update quest status" do
			quest = Quest.create(:title => "aaa")
			quest.update(:status => "OnIt")
			get :status, id: quest.id, string: "OnIt"
			expect(quest.status).to eq "OnIt"
		end
	end
	
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

  describe QuestsController do
    it "Create Quest" do
      quest = Quest.create(:title =>"aaa")
      put :create
      expect(quest.title).to eq "aaa"
    end
  end

  describe QuestsController do
    it "Edit Quest" do
      quest = Quest.create(:title =>"aaa")
      quest.update(:title => "bbb")
      put :update, id: quest.id
      expect(quest.title).to eq "bbb"
    end
  end

  describe QuestsController do
    it "Accept Quest" do
      quest = Quest.create(:title =>"aaa")
      user_quest = UsersQuest.create(:assignor_id => 1, :assignee_id=>2, :quest_id => quest.id)
      user_quest.update(:id => quest.id,:is_accepted => true,:is_rejected => false )
      put :accept, id: quest.id
      expect(user_quest.is_accepted).to eq true
    end
  end

  describe QuestsController do
    it "Reject Quest" do
      quest = Quest.create(:title =>"aaa")
      user_quest = UsersQuest.create(:assignor_id => 1, :assignee_id=>2, :quest_id => quest.id)
      user_quest.update(:id => quest.id,:is_accepted => false,:is_rejected => true )
      put :accept, id: quest.id
      expect(user_quest.is_accepted).to eq false
      expect(user_quest.is_rejected).to eq true
    end
  end
end
