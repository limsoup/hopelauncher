class StaticPagesController < ApplicationController
	def channel
		render '/layout/facebook/channel'
	end
	
	def intro
		render 'intro', :layout => false
	end
	def faq
	end
	def help
	end
end