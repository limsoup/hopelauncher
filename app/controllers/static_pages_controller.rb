class StaticPagesController < ApplicationController
	def channel
		render '/layouts/facebook/channel', :layout => false
	end
	
	def intro
	end
	
	def faq
	end

	def terms_of_service
	end

	def privacy_policy
	end
	
	def help
	end
end