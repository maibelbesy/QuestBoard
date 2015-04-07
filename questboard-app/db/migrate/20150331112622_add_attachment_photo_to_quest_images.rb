class AddAttachmentPhotoToQuestImages < ActiveRecord::Migration
  def self.up
    change_table :quest_images do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :quest_images, :photo
  end
end
