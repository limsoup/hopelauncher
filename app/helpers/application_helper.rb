require 'nokogiri'
require 'uri'
module ApplicationHelper
	def redirect_to_original_target(default)
		x = sessions[:original_target]
		sessions[:original_target] = nil
		redirect_to [ sessions[:original_target] || default ]
	end


	def redirect_to_save_target(options = {}, response_status = {})
		sessions[:original_target] = options[:original_target]
		redirect_to options, response_status
	end
	
	def msg_snippet(str)
		doc = Nokogiri::HTML(str)
		doc.search('//text()').map(&:text).join(" ").sub(/(.{137,})/,'\1...' )
	end

	# def conversation_path
	# end
end
