require 'uri'
class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		@user = User.find(params[:id])
		render 'show', :layout => '../users/user_dashboard'
	end

	def index
		@users = User.all
	end

end