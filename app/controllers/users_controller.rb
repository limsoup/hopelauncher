require 'uri'
class UsersController < ApplicationController
	load_and_authorize_resource

	def show
	end

	def index
		@users = User.all
	end

end