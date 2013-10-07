class UpdatesController < ApplicationController
	def create
		@project = Project.find(params[:project_id])
		@update = @project.updates.create(params[:update])
		redirect_to :controller => 'updates', :action => 'index', :project_id => @project.id
	end

	def destroy
		@project = Project.find(params[:project_id])
		@update = @project.updates.find(params[:id])
		@update.destroy
		redirect_to :controller => 'updates', :action => 'index', :project_id => @project.id
	end

	def index
	  @project = Project.find(params[:project_id])
	  @updates = @project.updates
	  @update = @project.updates.build
	  render 'index', :layout => '../projects/dashboard'
	end

	
	def edit
	  @project = Project.find(params[:project_id])
	  @update = @project.updates.find(params[:id])
	  render 'edit', :layout => '../projects/dashboard'
	end

	def update
	  @project = Project.find(params[:project_id])
	  @update = @project.updates.find(params[:id])
	  @update.update_attributes(params[:update])
	  redirect_to :controller => 'updates', :action => 'index', :project_id => @project.id
	end	
end
