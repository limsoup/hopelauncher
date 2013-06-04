class Donation < ActiveRecord::Base
	#attr_accessible :user, :project
  belongs_to :donator, :class_name => "User", :foreign_key => "user_id"
  belongs_to :donated_project, :class_name => "Project", :foreign_key => "project_id"
end
