class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new #guest user

		if user.role? :admin
			can :manage, :all
		elsif user.role? :author
			can :read, :all
			can :create, Project
			can [:update, :destroy], Project, :user_id => user.id
			can :create, Block, :project => { :user_id => user.id}
			# can :create, Block do |block|
			# 	# if block.project.user_id = user
			# 	# if Project.find(params[:project_id]).user_id == user.id
			# 	if @project.user_id == user.id
			# 		return true
			# 	else
			# 		return false
			# 	end
			# end
			can [:update, :destroy], Block, :project => { :user_id => user.id}
			can :manage, Donation
		else
			can :create, Donation
			can :read, :all
		end

		#make more secure later
		can :manage, [Message, Conversation, Notification]
		can :manage, User
	end

end
