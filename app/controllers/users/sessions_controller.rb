class Users::SessionsController < Devise::SessionsController
	before_filter :set_user_return_to_for_create_session, :only => :create
	before_filter :set_user_return_to, :only => [:new, :destroy]
	
	def set_user_return_to_for_create_session
		if request.referer != new_user_session_url and request.referer != new_user_registration_url
			session["user_return_to"] = request.referer
		end
	end

	def set_user_return_to
		session["user_return_to"] = request.referer
	end

	def create
		super
	end

	def new
		super
	end

	def destroy
		super
	end

end
