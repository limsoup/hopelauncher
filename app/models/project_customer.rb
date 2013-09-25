class ProjectCustomer < ActiveRecord::Base
	attr_accessible :user_id, :project_id, :stripe_customer_id
	belongs_to :user
	belongs_to :project
end