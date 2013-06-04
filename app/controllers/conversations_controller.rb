class ConversationsController < ApplicationController
	# before_filter :authorize_user!
	def index
		@conversations = mailbox.conversations
	end

	def thread
		@conversation = Conversation.find(params[:id])
		@new_message = @conversation.messages.build
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
	end

	def create
		@recipients = User.find(params[:message][:recipients].split.map {|n| n.to_i})
		# current_user.mailbox..conversations
		current_user.send_message(@recipients, params[:message][:body], params[:message][:subject])
		redirect_to 'inbox'
	end

	private

		def mailbox
			@mailbox ||= current_user.mailbox
		end
end