require 'uri'
class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		# @messages = @user.mailbox.messages
	end

	def index
		@users = User.all
	end

	def home
		render '/layouts/home'
	end

	def stripe_redirect
		logger.ap params[:code]
		logger.ap params
		access_token_request = Curl.post("https://connect.stripe.com/oauth/token", {
			:client_secret => CONFIG[:stripe_test_secret_key] ,
			:code => params[:code],
			:grant_type => 'authorization_code'
			})
		logger.ap access_token_request.body_str
	end
end