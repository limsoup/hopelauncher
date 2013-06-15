class Project < ActiveRecord::Base
  attr_accessible :title, :description
  belongs_to :user
  has_many :blocks
  belongs_to :creator, :class_name=> "User", :inverse_of => :created_projects, :foreign_key => "user_id"
  has_many :donations
  has_many :donators, :through => :user_projects, :class_name=> "User", :inverse_of => :donated_projects, :foreign_key => "user_id"
end
