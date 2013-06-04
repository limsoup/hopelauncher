class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def all
		# omniauth_hash = request.env["omniauth.auth"].merge
		user = User.from_omniauth(request.env["omniauth.auth"])
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