require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
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
