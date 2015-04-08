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

end
