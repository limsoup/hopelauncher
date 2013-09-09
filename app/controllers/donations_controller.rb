class DonationsController < ApplicationController

  # before_filter :authenticate_user!, :except => [:index, :show]
  # before_filter :authenticate_owner!, :only => [:edit, :update, :delete]

  load_and_authorize_resource #:except => [:new]

  # GET /projects
  # GET /projects.json
  def index
    @project = Project.find(params[:project_id])
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
    logger.ap @donations_with_info

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @donations }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @user = @donation.donator
    @project = Project.find(params[:project_id])
    @related_projects = Project.find(Project.pluck(:id).sample(3)) #eventually we want these projects to be local
    Stripe.api_key = @donation.donated_project.creator.stripe_secret_key
    @stripe_charge = Stripe::Charge.retrieve(@donation.stripe_charge_id)
    respond_to do |format|
      format.html { render 'show'} # show.html.erb
      format.json { render json: @donation }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @donation = current_user.donations.build

    respond_to do |format|
      format.html # new.html.erb
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

    # @donation = current_user.donations.create(params[:donation].slice(:amount, :project_id))
    if params[:donation][:amount] == 'variable'
      params[:donation][:amount] = params[:custom_amount].delete('$').lstrip
    end
    @donation = Donation.create(:amount => params[:donation][:amount], :project_id => params[:project_id], :user_id => (current_user ? current_user.id : nil ))
    logger.ap @donation
    # debugger
    Stripe.api_key = @donation.donated_project.creator.stripe_secret_key
    if current_user
      if current_user.stripe_customer_id.nil?
        customer = Stripe::Customer.create(
          :card  => params[:stripeToken]
        )
        current_user.update_attributes(:stripe_customer_id => customer.id)
      else
        begin
          customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
          if customer[:deleted] == true
            flash[:error] = "Your customer/payments account was deleted. For security reasons this can't be undone. Sorry!"
            redirect_to @donation.donated_project
          end
        rescue
          customer = Stripe::Customer.create(
            :card  => params[:stripeToken]
          )
          current_user.update_attributes(:stripe_customer_id => customer.id)
        end
      end
    else
      customer = Stripe::Customer.create(
        :card  => params[:stripeToken]
      )
    end
    logger.ap @donation
    begin
      @charge = Stripe::Charge.create(
        :customer => customer.id,
        :description => 'Donation via Hopelauncher',
        :amount => (params[:donation][:amount].to_f*100).to_i,
        :currency => 'usd'
        )
      @donation.update_attributes(:stripe_charge_id=> @charge.id)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to @donation.donated_project
    end
    @donation.project_id = params[:project_id]
    @project = Project.find(params[:project_id])
    respond_to do |format|
      # if @donation.save
      #   format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
      #   format.json { render json: @donation, status: :created, location: @donation }
      # else
      #   format.html { render action: "new" }
      #   format.json { render json: @donation.errors, status: :unprocessable_entity }
      # end
      if @donation.save
        @donation.donated_project.creator.send_message(current_user, render_to_string(:partial =>'/donations/mailers/thankyou.html.erb', :layout => 'stationary', :locals => {:@project => @project, :@charge => @charge, :@donation => @donation }).html_safe, "Thank you for your donation to #{@project.title}", false)
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
    # @project = Project.find(params[:id])
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
