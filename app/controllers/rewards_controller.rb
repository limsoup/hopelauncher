class RewardsController < ApplicationController

  load_and_authorize_resource :project
  load_and_authorize_resource :reward, :through => :project, :message => "You don't have access to manage this project's rewards."

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
	    render 'index', :layout => '../projects/dashboard'
	end

	def tracking
	    @project = Project.find(params[:project_id])
	    @donations  = @project.donations.find_all {|donation| donation.persisted? and donation.reward}.compact
	    render 'tracking', :layout => '../projects/dashboard'
	end
end