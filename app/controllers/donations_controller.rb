require 'json'

class DonationsController < ApplicationController

  # before_filter :authenticate_user!, :except => [:index, :show]
  # before_filter :authenticate_owner!, :only => [:edit, :update, :delete]

  load_and_authorize_resource #:except => [:new]

  # GET /projects
  # GET /projects.json
  def index
    @project = Project.find(params[:project_id])
    @donations = @project.donations
    # @donations.each do |donation|
    #     # donation_with_info = {:donation => donation}
    #     if donation.stripe_charge_id
    #       begin
    #         # stripe_charge = Stripe::Charge.retrieve(donation.stripe_charge_id)
    #         donation[:name] = donation.donator.nil? ? stripe_charge[:card][:name] : donation.donator.name
    #         donation[:status] = (stripe_charge[:failure_code] == nil && stripe_charge[:dispute] == nil) ? "Successful" : "Not Successful"
    #       rescue  Stripe::InvalidRequestError => e
    #         donation[:name] = donation.donator.nil? ? "Name Unknown" : donation.donator.name
    #         donation[:status] = "charge with #{donation.stripe_charge_id} not found"
    #       end
    #     else
    #       donation_with_info[:name] = donation.donator.nil? ?  "No Name Found" :  donation.donator.name 
    #       donation_with_info[:status] = "Not Successful: No Stripe Charge ID"
    #     end
    # end
    respond_to do |format|
      format.html { render 'index', :layout => '../projects/dashboard'}
      format.json { render json: @donations }
    end
  end

  def process_donation
    @project = Project.find(params[:project_id])
    @donation = @project.donations.find(params[:id])
    Stripe.api_key = @project.creator.stripe_secret_key
    # if @project.end < Time.now and @project.project_state == 'admin_approved'
        if @donation.stripe_charge_id.nil?
          # handle exceptions
          #potential schemes
          # - keep track of how much we owe, 
          # - tiers
          app_fee = ((0.021*@donation.amount - 30) > 0) ? (0.021*@donation.amount - 30).floor : 0
          # if (.21*donation.amount - 30) < 0)
          #   hopelauncher_owes = -1*(.21*donation.amount - 30) > 0)
          # else
          #   hopelauncher_owes = 0
          # end
          stripe_charge = Stripe::Charge.create ({
            :customer => @donation.project_customer.stripe_customer_id,
            :description => 'Donation via Hopelauncher',
            :amount => @donation.amount,
            :currency => 'usd',
            :card => @donation.stripe_card_id,
            :application_fee => app_fee
          })
          @donation.set_stripe_hash_with_params(nil, stripe_charge)
          @donation.stripe_charge_id = stripe_charge.id
          @donation.save
          @project.send_message(@donation.donator, render_to_string('/donations/mailers/thankyou_charged.html.erb', :layout => false, :locals => {:@project => @project, :@donation => @donation }).html_safe, "Thank you for your pledge to #{@project.title}", false)
          redirect_to donations_path(@project.id), :notice => "Pledge was processed successfully"
        else
          logger.ap JSON.parse(Stripe::Charge.retrieve(@donation.stripe_charge_id).to_json)
          redirect_to donations_path(@project.id), :notice => "This pledge has already been collected"
        end
    # else
    #   redirect_to donations_path(@project.id), :notice => "This project hasn't concluded, isn't approved for donations, or some other reason. If you are unsure of the problem, contact Hopelauncher's administrator."
    # end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @donation = Donation.find(params[:id])
    @user = @donation.donator
    @project = Project.find(params[:project_id])
    @related_projects = Project.find(Project.pluck(:id).sample(3)) #eventually we want these projects to be local
    # @project_customer = @donation.project_customer
    # Stripe.api_key = @donation.donated_project.creator.stripe_secret_key
    if @donation.stripe_charge_id.nil?
      # stripe_customer = Stripe::Customer.retrieve(@project_customer.stripe_customer_id)
      # stripe_card = stripe_customer.cards.retrieve(@donation.stripe_card_id)
      # @donation[:card_type] = stripe_card.type
      # @donation[:last4] = stripe_card.last4
      # @donation[:name] = stripe_card.name
      respond_to do |format|
        format.html { render 'show_pledge'} # show.html.erb
        format.json { render json: @donation }
      end
    else
      # stripe_charge = Stripe::Charge.retrieve(@donation.stripe_charge_id)
      # @donation[:card_type] = stripe_charge.card.type
      # @donation[:last4] = stripe_charge.card.last4
      # @donation[:name] = stripe_charge.card.name
      respond_to do |format|
        format.html { render 'show_donation'} # show.html.erb
        format.json { render json: @donation }
      end
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.find(params[:project_id])
    @rewards = @project.rewards.collect {|reward| reward.persisted? ? reward : nil }.compact
    @scale = !(@rewards.empty?) and @rewards[0].scale
    @project_participants = @project.project_participants.collect {|project_participant| project_participant.persisted? ? project_participant : nil }.compact
    @project_participants.each {|pp| pp[:name] = pp.name }

    respond_to do |format|
      format.html { render 'new'}
      format.json { render json: @donation }
    end
  end

  # GET /projects/1/edit
  def edit
    # @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.find(params[:project_id])
    Stripe.api_key = @project.creator.stripe_secret_key

    # @donation = current_user.donations.create(params[:donation].slice(:amount, :project_id))
    # [ ] pledge made
    #   [ ]customer account created or found
    #     [ ]Create Stripe Customer for Project with
    #       [ ]email, etc
    #       [ ]token from stripe checkout
    #     [ ]Create Stripe Card for Project
    #     [ ]Store Stripe Card in Customer
    #     Object
    #       [ ]project_id
    #       [ ]user_id
    #       [ ]stripe_customer_id
    #   [ ]create pledge
    #     [ ]card to use (cc_xxx...)
    #     [ ]amount
    #     [ ]project, user id
    #     [no] charge id

    if params[:donation][:amount] == 'variable'
      params[:donation][:amount] = params[:custom_amount].delete('$,').lstrip
    end

    project_customer = ProjectCustomer.where(:project_id => params[:project_id], :user_id => current_user.id).first
    if project_customer.nil?
      stripe_customer = Stripe::Customer.create(
        :card  => params[:stripeToken],
        :email => current_user.email
      )
      project_customer = ProjectCustomer.create(:stripe_customer_id => stripe_customer.id, :project_id => params[:project_id], :user_id => current_user.id)
    else
      stripe_customer = Stripe::Customer.retrieve(project_customer.stripe_customer_id)
    end
    stripe_card = stripe_customer.cards.retrieve(stripe_customer.cards.data[0].id)
    # rew_id = params[:donation][:reward][:id]
    @donation = Donation.create({
      :project_customer_id => project_customer.id,
      :stripe_card_id =>  stripe_customer.cards.data[0].id,
      :project_id => params[:project_id],
      :user_id => current_user.id,
      :amount => (params[:donation][:amount])
    })
    @donation.reward = Reward.find(params[:donation][:reward_id]) if(params[:donation][:reward_id])
    @donation.reward_quantity = params[:donation][:reward_quantity].to_i if(params[:donation][:reward_quantity])
    @donation.project_participant = @project.project_participants.find(params[:donation][:project_participant_id]) if params[:donation][:project_participant_id]
    @donation.set_stripe_hash_with_params(stripe_card, nil)
    # @donation[:card_type] = stripe_card.type
    # @donation[:last4] = stripe_card.last4
    # @donation[:name] = stripe_card.name
    # begin
    #   @charge = Stripe::Charge.create(
    #     :customer => customer.id,
    #     :description => 'Donation via Hopelauncher',
    #     :amount => (params[:donation][:amount].to_f*100).to_i,
    #     :currency => 'usd'
    #     )
    #   @donation.update_attributes(:stripe_charge_id=> @charge.id)
    # rescue Stripe::CardError => e
    #   flash[:error] = e.message
    #   redirect_to @donation.donated_project
    # end
    # @donation.project_id = params[:project_id]
    respond_to do |format|
      # if @donation.save
      #   format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
      #   format.json { render json: @donation, status: :created, location: @donation }
      # else
      #   format.html { render action: "new" }
      #   format.json { render json: @donation.errors, status: :unprocessable_entity }
      # end
      if @donation.save
        @donation.donated_project.send_message(current_user, render_to_string('/donations/mailers/thankyou_pledge.html.erb', :layout => false, :locals => {:@project => @project, :@charge => @charge, :@donation => @donation }).html_safe, "Thank you for your donation to #{@project.title}.", false)
        format.html { redirect_to [@project, @donation], notice: 'Donation was successfully created.' }
        format.json { render json: @donation, status: :created, location: @donation }
      else
        format.html { redirect_to @project, notice: 'Donation was not completed' }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    # @project = Project.find(params[:id])

    respond_to do |format|
      if @donation.update_attributes(params[:donation])
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to donations_url }
      format.json { head :no_content }
    end
  end

  # def donate
  #   @donation
  #   respond
  # end

  # private

    # def authenticate_owner!
    #   @project = Project.find(params[:id])
    #   if @project.user == current_user
    #     redirect_to_save_target new_user_session_path, :notice => "You must be logged in as a the owner of that project to continue.", :original_target => request.url
    #   end
    # end
end
