class CreateQuestImages < ActiveRecord::Migration
  def change
    create_table :quest_images do |t|
      t.string :caption
      t.integer :quest_id

      t.timestamps null: false
    end
  end
end
