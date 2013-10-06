class ProjectParticipant < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :project_id
	has_many :donations
	belongs_to :project

	validates :first_name, :last_name, {presence: true,  length: { in: 1..255 }}

	def name
		first_name.capitalize + ' ' + last_name[0]
	end
end