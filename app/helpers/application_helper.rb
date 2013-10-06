require 'nokogiri'
require 'uri'
module ApplicationHelper

	def dollar_amount(cents)
		"%#.2f" % (cents/100)
	end
	
	def active_link_to(link_list, delimiter = '&nbsp;&nbsp;&nbsp;', options = {})
		links = link_list.map do |link|
			if request.env['PATH_INFO'] == link[1]
				activeOptions = options
				if activeOptions[:class]
					activeOptions[:class] += " active"
				else
					activeOptions[:class] = " active"
				end
				link_to(link[0], link[1], activeOptions)
			else
				link_to(link[0], link[1], options)
			end
		end
		links.join(delimiter).html_safe
	end

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
		ret = doc.search('//text()').map(&:text).join(" ")
		if ret.length >40
			ret[/.{,40}/] + '...'
		else
			ret
		end
	end

	# def conversation_path
	# end
end
