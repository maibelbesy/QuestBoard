class CreateQuestVideos < ActiveRecord::Migration
  def change
    create_table :quest_videos do |t|
      t.string :url
      t.integer :quest_id

      t.timestamps null: false
    end
  end
end
