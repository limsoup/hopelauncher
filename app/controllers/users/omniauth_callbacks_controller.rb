class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token

	def all
		# omniauth_hash = request.env["omniauth.auth"].merge
		# debugger
		logger.ap current_user
		user = User.from_omniauth(request.env["omniauth.auth"], current_user)
		logger.ap request.env["omniauth.auth"]
		if user.persisted?
			flash.notice = "Signed in!"
			sign_in_and_redirect user
		else
			session["devise.user_attributes"] = user.attributes
			#save authorizations data to the session
			redirect_to new_user_registration_url
		end
	end
	[:twitter, :facebook, :stripe_connect].each {|provider| alias_method provider, :all}
end