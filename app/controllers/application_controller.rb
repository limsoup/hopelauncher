class ApplicationController < ActionController::Base
  protect_from_forgery

  def channel
  	render '/layouts/facebook/channel'
  end
  rescue_from CanCan::AccessDenied do |exception|
	Rails.logger "Access denied on #{exception.action} #{exception.subject.inspect}"
  end

end
