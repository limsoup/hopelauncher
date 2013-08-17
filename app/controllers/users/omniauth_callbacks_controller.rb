class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	# load_and_authorize_resource
  skip_before_filter :verify_authenticity_token

	def all
		# omniauth_hash = request.env["omniauth.auth"].merge
		# debugger
		# puts current_user
		user = User.from_omniauth(request.env["omniauth.auth"], current_user)
		# puts request.env["omniauth.auth"]
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