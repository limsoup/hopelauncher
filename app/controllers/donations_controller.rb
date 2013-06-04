class DonationsController < ApplicationController

  # before_filter :authenticate_user!, :except => [:index, :show]
  # before_filter :authenticate_owner!, :only => [:edit, :update, :delete]

  load_and_authorize_resource #:except => [:new]

  # GET /projects
  # GET /projects.json
  def index
    # @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @donations }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
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
    @donation = current_user.donations.build(params[:donation], params[:project_id])
    if current_user.stripe_customer_id
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card  => params[:stripeToken]
      )
    else
      customer = Stripe::Customer.retrieve(current_user.user)
      if customer.deleted == true
        flash[:error] = "Your customer/payments account was deleted. For security reasons this can't be undone. Sorry!"
        redirect_to @donation.donated_project
      else
        charge = Stripe::Charge.create(
          :customer => customer.id,
          :description => 'Donation to '+@donation.project.title +' via Hopelauncher',
          :amount => params[:amount],
          :currency => 'usd'
          )
        rescue Stripe::CardError => e
          flash[:error] = e.message
          redirect_to @donation.donated_project
        end
      end
    end
    @donation.project_id = params[:project_id]
    respond_to do |format|
      # if @donation.save
      #   format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
      #   format.json { render json: @donation, status: :created, location: @donation }
      # else
      #   format.html { render action: "new" }
      #   format.json { render json: @donation.errors, status: :unprocessable_entity }
      # end
      if @donation.save
        format.html { redirect_to @donation.donated_project, notice: 'Donation was successfully created.' }
        format.json { render json: @donation, status: :created, location: @donation }
      else
        format.html { render action: "new" }
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

  private

    # def authenticate_owner!
    #   @project = Project.find(params[:id])
    #   if @project.user == current_user
    #     redirect_to_save_target new_user_session_path, :notice => "You must be logged in as a the owner of that project to continue.", :original_target => request.url
    #   end
    # end
end
