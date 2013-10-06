class ProjectParticipantsController < ApplicationController
	def create
		@project = Project.find(params[:project_id])
		@project_participant = @project.project_participants.create(params[:project_participant])
		if @project_participant.save
			redirect_to :controller => 'project_participants', :action => 'index', :project_id => @project.id
		else
			redirect_to :controller => 'project_participants', :action => 'index', :project_id => @project.id
		end
	end

	def destroy
		@project = Project.find(params[:project_id])
		@project_participant = @project.project_participants.find(params[:id])
		@project_participant.destroy
		respond_to do |format|
	      format.js { render :nothing => true }
	      format.html { redirect_to :controller => 'project_participants', :action => 'index', :project_id => @project.id }
	    end
	end

	def index
	    @project = Project.find(params[:project_id])
	    @project_participants = @project.project_participants
	    @project_participant = @project.project_participants.build
	    render 'index', :layout => '../projects/dashboard'
	end

	def tracking
	    @project = Project.find(params[:project_id])
	    @project_participants = @project.project_participants
	    @project_participants.each do |pp|
	    	sum = 0
	    	pp.donations.each do |d|
	    		sum += d.amount if d.amount
	    	end
	    	pp[:total] = sum
	    end
	    render 'tracking', :layout => '../projects/dashboard'
	end

	def show
	    @project = Project.find(params[:project_id])
	    @project_participant = @project.project_participants.find(params[:id])
	    @donations = @project_participant.donations
    	sum = 0
    	@project_participant.donations.each do |d|
    		sum += d.amount if d.amount
    	end
    	@project_participant[:total] = sum
	    render 'show', :layout => '../projects/dashboard'
	end
end