require 'csv'

class ProjectParticipant < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :middle_name, :project_id
	has_many :donations
	belongs_to :project

	validates :first_name, :last_name, {presence: true,  length: { in: 1..255 }}

	def name
		first_name.capitalize + ' '+ ((middle_name and !(middle_name.blank?)) ? (middle_name.split(' ').map {|m| m[0].capitalize}.join('. ') + '. ') : '') + last_name[0].capitalize + '.'
	end

	def full_name
		first_name.capitalize + ' '+(middle_name ? middle_name : '') + ' ' + last_name.capitalize
	end

	def collected
		sum = 0
		donations.each {|d| sum += d.amount if (d.amount)}
		sum
	end

	def collected_dollar_amount
		"%#.2f" % (collected/100)
	end

	def self.import(file, project_id)
		CSV.foreach(file.path, headers: false) do |row|
			ProjectParticipant.create( first_name:row[0], middle_name:(row[1] ? row[1] : ''), last_name:row[2], :project_id => project_id)
		end
	end
end