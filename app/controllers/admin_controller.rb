class AdminController < ApplicationController
	def users
		@style = {
			'unapproved' => { :row_class => 'error' },
			'changes_needed' => { :row_class => 'warning' },
			'under_review' => { :row_class => 'info' },
			'approved' => { :row_class => 'success' }
		}
		@users = User.where(:account_type => 'project_creator')
		render 'users', :layout => '../admin/dashboard'
	end

	def approve_user
		@user = User.find(params[:id])
		@user.account_state = 'approved'
		@user.save
		redirect_to new_user_conversation_url+"?recipient=#{@user.id}&subject=Account Status and Approval"
	end

	def reject_user
		@user = User.find(params[:id])
		@user.account_state = 'needs_work'
		@user.save
		redirect_to new_user_conversation_url+"?recipient=#{@user.id}&subject=Account Status and Approval"
	end

	def approve_project
		@project = Project.find(params[:id])
		@project.project_state = 'admin_approved'
		@project.save
		redirect_to new_user_conversation_url+"?recipient=#{@project.creator.id}&subject=Project Status and Approval"
	end

	def reject_project
		@project = Project.find(params[:id])
		@project.project_state = 'needs_work'
		@project.save
		redirect_to new_user_conversation_url+"?recipient=#{@project.creator.id}&subject=Project Status and Approval"
	end

	def projects
		@style = {
			'unapproved' => { :row_class => 'error' },
			'creator_approved' => { :row_class => 'warning' },
			'admin_approved' => { :row_class => 'info' },
			'approved' => { :row_class => 'success' }
		}
		@projects = Project.all
		render 'projects', :layout => '../admin/dashboard'
	end

	def donations
		render 'donations', :layout => '../admin/dashboard'
	end
end