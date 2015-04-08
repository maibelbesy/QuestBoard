require 'rails_helper'

RSpec.describe TaskController, type: :controller do

	it "Add Task to certain Quest" do
		##Create a Quest and add tasks to it 
		##expect tasks to be as inserted
		quest = Quest.create(:title => "Test Quest for Tasks" , :description => "Quest in RSPEC to test Tasks Controller")
		task = Task.create(:quest_id =>quest.id, :user_id => 1, :title => "Task Test on Quest 1")
		expect(task.quest_id).to eq quest.id
		expect(task.title).to eq "Task Test on Quest 1"

	end
end
