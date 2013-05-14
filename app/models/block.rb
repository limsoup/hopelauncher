class Block < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :content, :user_id, :project_id
  belongs_to :project
  belongs_to :user
end
