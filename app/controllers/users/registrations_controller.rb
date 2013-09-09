class Users::RegistrationsController < Devise::RegistrationsController
	# load_and_authorize_resource 
	
	def edit_account
		@user = User.find(params[:id])
		render 'edit_account', :layout => '../users/registrations/user_edit_template'
	end

	def edit_profile
		@user = User.find(params[:id])
		render 'edit_profile', :layout => '../users/registrations/user_edit_template'
	end


    def submit
      @user = User.find(params[:id])
      @user.account_state = 'under_review'
      @user.save
  	  render 'edit_account', :layout => '../users/registrations/user_edit_template'
    end

	def show
		# @messages = @user.mailbox.messages
		@user = User.find(params[:id])
	end

	def index
		@users = User.all
	end

	def update
	  #   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
	  #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

			# resource_params_var = resource_params
			# if resource_params_var[:current_password] == ""
			# 	[:current_password, :password_confirmation, :password].each {|pw| resource_params_var.delete pw}
			# 	update_return = resource.update_without_password(resource_params_var)
			# else
			# 	update_return = resource.update_with_password(resource_params_var)
			# end

	  #   if update_return
	  #     if is_navigational_format?
	  #       flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
	  #         :update_needs_confirmation : :updated
	  #       set_flash_message :notice, flash_key
	  #     end
	  #     sign_in resource_name, resource, :bypass => true
	  #     respond_with resource, :location => after_update_path_for(resource)
	  #   else
	  #     clean_up_passwords resource
	  #     respond_with resource
	  #   end
  	    @user = User.find(current_user.id)
        if params[:user][:current_password].blank?
	      params[:user].delete("current_password")
	      if @user.update_without_password(params[:user])
		    # set_flash_message :notice, :updated
	        # redirect_to @user
	        logger.ap 'update without password succeeded?'
		  	render 'edit_account', :layout => '../users/registrations/user_edit_template'
		  else
		  	logger.ap 'update without password failed?'
		  	render 'edit_account', :layout => '../users/registrations/user_edit_template'
		  end
	    else
	      if @user.update_with_password(params[:user])
		      # set_flash_message :notice, :updated
		      # redirect_to @user
		  	render 'edit_account', :layout => '../users/registrations/user_edit_template'
		  else
		  	render 'edit_account', :layout => '../users/registrations/user_edit_template'
		  end
	    end

	    # if @user.update_attributes(params[:user])
	    #   set_flash_message :notice, :updated
	    #   # Sign in the user bypassing validation in case his password changed
	    #   sign_in @user, :bypass => true
	    #   redirect_to after_update_path_for(@user)
	    # else
	    #   render "edit"
	    # end
	end

	# protected

	#   def update_needs_confirmation?(resource, previous)
	#     resource.respond_to?(:pending_reconfirmation?) &&
	#       resource.pending_reconfirmation? &&
	#       previous != resource.unconfirmed_email
	#   end

	#   # Build a devise resource passing in the session. Useful to move
	#   # temporary session data to the newly created user.
	#   def build_resource(hash=nil)
	#     self.resource = resource_class.new_with_session(hash || {}, session)
	#   end

	#   # Signs in a user on sign up. You can overwrite this method in your own
	#   # RegistrationsController.
	#   def sign_up(resource_name, resource)
	#     sign_in(resource_name, resource)
	#   end

	#   # The path used after sign up. You need to overwrite this method
	#   # in your own RegistrationsController.
	   def after_sign_up_path_for(resource)
	   	logger.ap 'lol'
	    redirect_to stored_location_for(:user) || root_path
	   end

	#   # The path used after sign up for inactive accounts. You need to overwrite
	#   # this method in your own RegistrationsController.
	#   def after_inactive_sign_up_path_for(resource)
	#     respond_to?(:root_path) ? root_path : "/"
	#   end

	#   # The default url to be used after updating a resource. You need to overwrite
	#   # this method in your own RegistrationsController.
	#   def after_update_path_for(resource)
	#     signed_in_root_path(resource)
	#   end

	#   # Authenticates the current scope and gets the current resource from the session.
	#   def authenticate_scope!
	#     send(:"authenticate_#{resource_name}!", :force => true)
	#     self.resource = send(:"current_#{resource_name}")
	#   end

	#   def sign_up_params
	#     devise_parameter_sanitizer.for(:sign_up)
	#   end

	#   def account_update_params
	#     devise_parameter_sanitizer.for(:account_update)
	#   end

end