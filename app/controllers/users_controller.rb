require 'uri'
class UsersController < ApplicationController
	load_and_authorize_resource

	def show
		@user = User.find(params[:id])
		render 'show', :layout => '../users/user_dashboard'
	end

	def projects
      @user = User.find(params[:id])
      @donated_projects = @user.donated_projects
      @created_projects = @user.created_projects
      @followed_projects = @user.followed_projects
  	  render 'projects', :layout => '../users/user_dashboard'
	end

	def index
		@users = User.all
	end

end