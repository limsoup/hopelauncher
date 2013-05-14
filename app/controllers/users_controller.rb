class UsersController < ApplicationController
	def new
		# @user = User.new
		# render 'new'
	end

	def edit
	end

	def show
	end

	def index
		@users = User.all
	end

	def home
		render '/layouts/home'
	end

	def destroy
	end
end