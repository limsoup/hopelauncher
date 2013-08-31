class FollowingsController < ApplicationController
	# load_and_authorize_resource

	def create
		@project = Project.find(params[:project_id])
		@following = @project.followings.build(:user_id => current_user.id)
		@following.save
		redirect_to @project, :notice => "You are now following #{@project.title}."
	end

	def destroy
		@project = Project.find(params[:project_id])
		@following = @project.followings.find(params[:id])
		@following.destroy
		redirect_to @project, :notice => "You are no longer following #{@project.title}."
	end
end