class ProjectsController < ApplicationController

  # before_filter :authenticate_user!, :except => [:index, :show]
  # before_filter :authenticate_owner!, :only => [:edit, :update, :delete]

  load_and_authorize_resource :except => [:new, :index]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(:project_state => 'admin_approved')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # @project = Project.find(params[:id])
    # logger.ap @project
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = current_user.created_projects.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    # @project = Project.find(params[:id])
  end

  # def dashboard
  #   @project = Project.find(params[:id])
  #   @donations = @project.donations
  # end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.created_projects.build(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    # @project = Project.find(params[:id])

    # params[:project][:start_date]
    # params[:project][:end_date]
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_message
    #get recipient
    
    # reflected in form in ERb file
    recipients = []
    # if params[:message][:group] == 'followers'
    #   # there's nothing for 'followers' yet
    # elsif params[:message][:group] == 'donators'
      recipients += @project.donators
    # end

    
    #**** finish when we have invidividual recipients in irb
    # # later, i should just make the values the same as the attribute names
    # if params[:message][:group] != "none"
    #   if params[:message][:group] == 'followers'
    #     # there's nothing for 'followers' yet
    #   elsif params[:message][:group] == 'donators'
    #     recipients << @project.donators
    #   end
    # enda
    # #individual 

    #send the messages
    logger.ap recipients.uniq!
    @project.send_message(recipients, params[:message][:body], params[:message][:subject])
    redirect_to :action => 'dashboard'
  end

  def dashboard
    # #message boxes
    # @inbox_conversations = @project.mailbox.inbox
    # @sentbox_conversations = @project.mailbox.sentbox
    
    # # @new_conversation = Conversation.new
    # @new_message = Message.new #this should be a 'project message'
    # @project = Project.find(params[:id])
    # @donations = @project.donations
    # @donations_with_info = []
    # Stripe.api_key = @project.creator.stripe_connect_authorization_token
    # @donations.each do |donation|
    #     donation_with_info = {:donation => donation}
    #     if donation.stripe_charge_id
    #       begin
    #         stripe_charge = Stripe::Charge.retrieve(donation.stripe_charge_id)
    #         donation_with_info[:name] = donation.donator.nil? ? stripe_charge[:card][:name] : donation.donator.name
    #         donation_with_info[:status] = (stripe_charge[:failure_code] == nil && stripe_charge[:dispute] == nil) ? "Successful" : "Not Successful"
    #       rescue  Stripe::InvalidRequestError => e
    #         donation_with_info[:name] = donation.donator.nil? ? "Name Unknown" : donation.donator.name
    #         donation_with_info[:status] = "charge with #{donation.stripe_charge_id} not found"
    #       end
    #     else
    #       donation_with_info[:name] = donation.donator.nil? ?  "No Name Found" :  donation.donator.name 
    #       donation_with_info[:status] = "Not Successful: No Stripe Charge ID"
    #     end
    #   @donations_with_info << donation_with_info
    # end
    redirect_to :action => 'project_communications'
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    # @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  # def donate
  #   @donate do 
  # end
  

  def donations
    @project = Project.find(params[:id])

    @donations = @project.donations
    @donations_with_info = []
    Stripe.api_key = @project.creator.stripe_secret_key
    @donations.each do |donation|
        donation_with_info = {:donation => donation}
        if donation.stripe_charge_id
          begin
            stripe_charge = Stripe::Charge.retrieve(donation.stripe_charge_id)
            donation_with_info[:name] = donation.donator.nil? ? stripe_charge[:card][:name] : donation.donator.name
            donation_with_info[:status] = (stripe_charge[:failure_code] == nil && stripe_charge[:dispute] == nil) ? "Successful" : "Not Successful"
          rescue  Stripe::InvalidRequestError => e
            donation_with_info[:name] = donation.donator.nil? ? "Name Unknown" : donation.donator.name
            donation_with_info[:status] = "charge with #{donation.stripe_charge_id} not found"
          end
        else
          donation_with_info[:name] = donation.donator.nil? ?  "No Name Found" :  donation.donator.name 
          donation_with_info[:status] = "Not Successful: No Stripe Charge ID"
        end
      @donations_with_info << donation_with_info
    end
    render 'donations', :layout => '../projects/dashboard'
  end

  def project_communications
    @project = Project.find(params[:id])

    #message boxes
    @inbox_conversations = @project.mailbox.inbox
    @sentbox_conversations = @project.mailbox.sentbox
    
    # @new_conversation = Conversation.new
    @new_message = Message.new #this should be a 'project message'
    render 'project_communications', :layout => '../projects/dashboard'
  end

  def edit_gallery
    @project = Project.find(params[:id])
    render 'edit_gallery', :layout => '../projects/dashboard'
  end

  def edit_content
    @project = Project.find(params[:id])
    render 'edit_content', :layout => '../projects/dashboard'
  end

  def edit_settings
    @project = Project.find(params[:id])
    render 'edit_settings', :layout => '../projects/dashboard'
  end

  def staging
    @project = Project.find(params[:id])
    render 'staging', :layout => '../projects/dashboard'
  end

  def updates
    @project = Project.find(params[:id])
    @updates = @project.updates
    logger.ap @updates
    @update = @project.updates.build()
    render 'edit_updates', :layout => '../projects/dashboard'
  end

  def submit
    @project = Project.find(params[:id])
    @project.project_state = 'creator_approved'
    @project.save
    # render 'staging', :layout => '../projects/dashboard'
    redirect_to :action => :staging
  end


  def by_short_path
    @project = Project.find_by_short_path(params[:short_path])
    render 'show'
  end

  private

    # def authenticate_owner!
    #   @project = Project.find(params[:id])
    #   if @project.user == current_user
    #     redirect_to_save_target new_user_session_path, :notice => "You must be logged in as a the owner of that project to continue.", :original_target => request.url
    #   end
    # end
end
