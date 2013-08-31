class ConversationsController < ApplicationController
	# before_filter :authorize_user!
	def index
		@conversations = mailbox.conversations
	end

	def show
		@conversation = Conversation.find(params[:id])
		@new_message = @conversation.messages.build
		render 'thread'
	end

	def show_message
		@new_message = Message.find(params[:id])
	end

	def reply
		#do specific reply later, this is reply-all
		@conversation = Conversation.find(params[:id])
		current_user.reply_to_conversation(@conversation, params[:message][:body])
		redirect_to @conversation
	end

	def mailbox
		@conversations = mailbox.send(params[:action])
		render '/messages/box'
	end

	def drafts
		@conversations = mailbox.conversations(:drafts => true)
		render '/messages/box'
	end
	[:inbox, :sentbox, :deleted].each {|box| alias_method box, :mailbox}

	def new
		@message = Message.new
		if params[:subject]
			@message.subject = params[:subject]
		end
	end

	def recipients
		respond_to do |format|
			# :class => 'Project', 
			# :class => 'User', 
		  projects = Project.all.collect {|p| (p.title.nil? ? '' : p.title).downcase.include?(params[:q]) ? { :id => "[{#{p.id}} {Project}]", :name => p.title} : nil }.compact
		  donators = current_user.created_projects.collect {|p| p.donators + p.followers}.flatten.uniq.collect {|u|  u.name.downcase.include?(params[:q]) ? {:id => "[{#{u.id}} {User}]", :name => u.name} : nil }.compact
		  # followers = current_user.created_projects.collect {|p| p.followers}.flatten.uniq.collect {|u|  u.name.downcase.include?(params[:q]) ? {:id => "[{#{u.id}} {User}]", :name => u.name} : nil }.compact
	      format.json {
	      	render json: projects +donators
	      }
	    end
	end

	def create
		logger.ap params
		# if params[:message][:project_id]
		# 	@project = Project.find params[:message][:project_id]
		# 	if params[:message][:recipients] == 'followers'
		# 		#followers not there yet
		# 	else params[:message][:donators] == 'donators'
		# 		@recipients = @project.donators
		# 	end
		# else
		@recipients = []
		recipients_array = params[:message][:recipients].split('],[').collect {|r| r.delete(']').delete('[')}
		recipients_array.each do |token|
			kv = token.split('} {')
			logger.ap token
			logger.ap kv[0].delete('{').delete('}')
			logger.ap kv[1].delete('{').delete('}')
			@recipients << kv[1].delete('{').delete('}').constantize.find(kv[0].delete('{').delete('}').to_i)
		end
		# @recipients = User.find((params[:message][:recipients].split.map {|n| n.to_i}).uniq.compact)
		# end
		if @recipients
			current_user.send_message(@recipients, params[:message][:body], params[:message][:subject])
		end
		redirect_to request.referer
	end


	def project_message_create
		@project = Project.find params[:message][:project_id]
		if params[:message][:recipients] == 'followers'
			@recipients = @project.followers
		elsif params[:message][:donators] == 'donators'
			@recipients = @project.donators
		end
		@recipients.uniq!.compact!
		if @recipients
			current_user.send_message(@recipients, params[:message][:body], params[:message][:subject])
		end
		redirect_to request.referer
	end

	private

		def mailbox
			@mailbox ||= current_user.mailbox
		end
end