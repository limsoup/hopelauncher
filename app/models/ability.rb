class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new #guest user
		if user.role? :admin
			can :manage, :all
		elsif user.role? :author
			can :manage, Project, :user_id => user.id
			can [:read,:create], Project

			can :manage, [Reward, Update, ProjectParticipant], :project => {:user_id => user.id}
			can :manage, Donation, :donated_project => {:user_id => user.id}
			can :read, Donation, :user_id => user.id
			can :create, Donation

			can :manage, GalleryImage do |gi|
				gi.project.creator.id == user.id
			end
			# can :create, Block, :project => { :user_id => user.id}
			# can :create, Block do |block|
			# 	# if block.project.user_id = user
			# 	# if Project.find(params[:project_id]).user_id == user.id
			# 	if @project.user_id == user.id
			# 		return true
			# 	else
			# 		return false
			# 	end
			# end
			# can [:update, :destroy], Block, :project => { :user_id => user.id}
			# can :manage, Donation do |d|
			# 	d.donated_project.creator.id == user.id or d.donator.id == user.id
			# end
			can :manage, User, :id => user.id
		else user.role? :user
			can :manage, User, :id => user.id
			can :create, Donation
			can :read, Donation, :donator_id => user.id
			can [:read, :update, :destroy], Following, :user_id => user.id
			can :create, Following do |following|
				following.followed_project.active?
			end
			can :read, :all
		end

		#make more secure later
		can :manage, [Message, Conversation, Notification]
		can :read, Project
		can [:show, :create], User
	end

end
