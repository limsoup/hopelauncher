class ApplicationController < ActionController::Base
  protect_from_forgery

  def channel
  	render '/layouts/facebook/channel'
  end
end
