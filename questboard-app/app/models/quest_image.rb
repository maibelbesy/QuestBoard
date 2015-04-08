class QuestImage < ActiveRecord::Base
belongs_to :quest
has_attached_file :photo, :styles => { :small => "150x150>", :large => "320x240>" }
  do_not_validate_attachment_file_type :photo

end
