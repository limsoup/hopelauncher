class UpdatesController < ApplicationController
	def create
		@project = Project.find(params[:project_id])
		@update = @project.updates.create(params[:update])
		redirect_to :controller => 'projects', :action => 'updates', :id => @project.id
	end
end