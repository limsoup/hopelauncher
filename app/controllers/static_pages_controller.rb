class StaticPagesController < ApplicationController
	def channel
		render '/layouts/facebook/channel', :layout => false
	end
	
	def intro
	end
	def faq
	end
	def help
	end
end