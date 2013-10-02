class RewardsController < ApplicationController
	def create
		@project = Project.find(params[:project_id])
		@reward = @project.rewards.create(params[:reward])
		if @reward.save
			redirect_to :controller => 'rewards', :action => 'index', :project_id => @project.id
		else
			redirect_to :controller => 'rewards', :action => 'index', :project_id => @project.id
		end
	end

	def destroy
		@project = Project.find(params[:project_id])
		@reward = @project.rewards.find(params[:id])
		@reward.destroy
		respond_to do |format|
	      format.js { render :nothing => true }
	      format.html { redirect_to :controller => 'rewards', :action => 'index', :project_id => @project.id }
	    end
	end

	def index
	    @project = Project.find(params[:project_id])
	    @rewards = @project.rewards
	    @reward = @project.rewards.build
	    render '/projects/rewards', :layout => '../projects/dashboard'
	end
end