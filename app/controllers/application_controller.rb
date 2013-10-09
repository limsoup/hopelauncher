class ApplicationController < ActionController::Base
  protect_from_forgery

  def channel
  	render '/layouts/facebook/channel'
  end
  
  # def after_sign_out_path_for(resource)
  #   request.env['omniauth.origin'] || stored_location_for(current_user) || root_path
  # end

  # def after_sign_in_path_for(resource)
  #   request.env['omniauth.origin'] || stored_location_for(current_user) || root_path
  # end

  rescue_from CanCan::AccessDenied do |exception|
	   Rails.logger.info "Access denied on #{exception.action} #{exception.subject.inspect}"
     redirect_to projects_path, :notice => exception.message 
  end


end
