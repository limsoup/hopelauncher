class ConversationsController < ApplicationController
	# before_filter :authorize_user!


	
	#--- ALL (like all messages) METHODS ----
	def mailbox
		@user = current_user
		projects_conversations = current_user.created_projects.map {|project| project.mailbox.send(params[:action] ).map { |conversation| conversation[:project_name] = project.title; conversation[:project_id] = project.id; conversation }.sort { |a,b| a.last_message.created_at <=> b.last_message.created_at } }
		user_conversations = current_user.mailbox.send(params[:action] ).sort { |a,b| a.last_message.created_at <=> a.last_message.created_at }
		logger.ap projects_conversations
		conversation_groups = (projects_conversations << user_conversations)
		logger.ap conversation_groups
		@conversations = []
		total_count = 0
		conversation_groups.each {|x| total_count += x.count }
		total_count.times do
			@conversations.unshift(conversation_groups[conversation_groups.each_with_index.map {|x,i| x.empty? ? nil : [x.last, i] }.compact.min_by {|y| y[0].last_message.created_at }[1]].pop)
		end
		@conversations = @conversations.find_all{|conv| conv.participants.all? {|p| !(p.nil?)} and !(conv.originator.nil?)}
		render '/messages/box', :layout => '../users/user_dashboard'
	end

	[:inbox, :sentbox, :deleted].each {|box| alias_method box, :mailbox}

	#--- USER METHODS ----

	def new_user_conversation
		@user = current_user
		@message = Message.new
		if params[:subject]
			@message.subject = params[:subject]
		end
		render 'user_new' , :layout => '../users/user_dashboard'
	end

	def show_user_conversation
		@user =current_user
		@conversation = Conversation.find(params[:id])
		@new_message = @conversation.messages.build
		@conversation.mark_as_read(@user)
		render 'thread' , :layout => '../users/user_dashboard'
	end

	def reply_user_conversation
		#do specific reply later, this is reply-all
		@conversation = Conversation.find(params[:id])
		current_user.reply_to_conversation(@conversation, params[:message][:body])
		redirect_to user_conversation_path(@conversation)
	end

	def create_user_conversation
		@recipients = []
		recipients_array = params[:message][:recipients].split('],[').collect {|r| r.delete(']').delete('[')}
		recipients_array.each do |token|
			kv = token.split('} {')
			logger.ap token
			logger.ap kv[0].delete('{').delete('}')
			logger.ap kv[1].delete('{').delete('}')
			@recipients << kv[1].delete('{').delete('}').constantize.find(kv[0].delete('{').delete('}').to_i)
		end
		if @recipients
			current_user.send_message(@recipients, params[:message][:body], params[:message][:subject])
		end
		redirect_to request.referer
	end

	def delete_user_conversation
		@conversation = Conversation.find(params[:id])
		@conversation.move_to_trash(current_user)
		redirect_to user_inbox_path
	end

	def user_mailbox
		@user = current_user
		@conversations = mailbox.send(params[:action].scan(/([a-zA-Z]+)_([a-zA-Z]+)/)[0][1])
		@conversations = @conversations.find_all{|conv| conv.participants.all? {|p| !(p.nil?) } and !(conv.originator.nil?)}
		render '/messages/box', :layout => '../users/user_dashboard'
	end


	[:user_inbox, :user_sentbox, :user_trash].each {|box| alias_method box, :user_mailbox}


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

	def project_recipients
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

    #-----PROJECT METHODS----

	def new_project_conversation
		@user = current_user
		@project = Project.find(params[:project_id])
		@message = Message.new
		if params[:subject]
			@message.subject = params[:subject]
		end
		render 'project_new', :layout => '../users/user_dashboard'
	end

	def show_project_conversation
		@project = Project.find(params[:project_id])
		@user = current_user
		@conversation = Conversation.find(params[:id])
		@new_message = @conversation.messages.build
		@conversation.mark_as_read(@project)
		render 'thread' , :layout => '../users/user_dashboard'
	end

	def reply_project_conversation
		@project = Project.find(params[:project_id])
		#do specific reply later, this is reply-all
		@conversation = Conversation.find(params[:id])
		current_user.reply_to_conversation(@conversation, params[:message][:body])
		redirect_to @conversation
	end

	def create_project_conversation
		@project = Project.find(params[:project_id])
		logger.ap params
		if params[:message][:group] == 'followers'
			@recipients = @project.followers
		elsif params[:message][:group] == 'donators'
			@recipients = @project.donators
		end
		if @recipients
			@recipients.uniq!.compact!
			logger.ap @recipients
			@project.send_message(@recipients, params[:message][:body], params[:message][:subject])
		end
		redirect_to request.referer
	end

	def delete_project_conversation
		@project = Project.find(params[:project_id])
		@conversation = Conversation.find(params[:id])
		@conversation.move_to_trash(@project)
		redirect_to project_inbox_path(@project)
	end

	def project_mailbox
		@user = current_user
		@project = current_user.created_projects.find(params[:project_id])
		@conversations = @project.mailbox.send(params[:action].scan(/([a-zA-Z]+)_([a-zA-Z]+)/)[0][1])
		@conversations = @conversations.find_all{|conv| conv.participants.all? {|p| !(p.nil?) } and !(conv.originator.nil?)}
		render '/messages/box', :layout => '../users/user_dashboard'
	end


	[:project_inbox, :project_sentbox, :project_trash].each {|box| alias_method box, :project_mailbox}


	def new
		@message = Message.new
		if params[:subject]
			@message.subject = params[:subject]
		end
	end

	private

		def mailbox
			@mailbox ||= current_user.mailbox
			# @user ||= current_user
		end
end