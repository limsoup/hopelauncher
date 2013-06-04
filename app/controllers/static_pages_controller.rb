class StaticPagesController < ApplicationController
	def channel
		render '/layout/facebook/channel'
	end
end