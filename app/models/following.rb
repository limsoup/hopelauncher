class Following < ActiveRecord::Base
	attr_accessible :user_id, :project_id
  belongs_to :follower, :class_name => "User", :foreign_key => "user_id"
  belongs_to :followed_project, :class_name => "Project", :foreign_key => "project_id"
end