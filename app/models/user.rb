require 'uri'
class User < ActiveRecord::Base
	acts_as_messageable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :stripe_connect]

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles_mask, :stripe_publishable_key, :stripe_customer_id,
  :display_name, :legal_name, :statement_name, :statement_number, :ein, :first_name, :last_name, :description, :date_of_birth, :street, :city,
  :state, :zip, :country, :under_review, :image, :remote_image_url, :account_type, :profile_image_url, :terms_of_service

  attr_protected :stripe_secret_key, :account_state

  # validates_acceptance_of :terms_of_service, :allow_nil => false, :accept => true, :on => :create
  validates_acceptance_of :terms_of_service
  validates :account_type, inclusion: {in: %w(member project_creator) }
  validates :account_state, inclusion: {in: %w(unapproved under_review approved changes_needed) }

	before_save :default_role

	has_many :donations
    has_many :donated_projects, :through => :donations, :class_name => "Project", :inverse_of => :donators, :foreign_key => "project_id"
    has_many :followings
	has_many :followed_projects, :through => :followings, :class_name => "Project", :inverse_of => :followers, :foreign_key => "project_id"
	has_many :created_projects, :class_name => "Project", :inverse_of => :creator
	has_many :authorizations

	mount_uploader :image, ImageUploader
	ROLES = %w[admin mod author user] 
	STRIPE_PARAMETERS = %w[email].map {|x| x.to_sym}

	def roles=(new_roles)
		# roles.map! {|r| r.to_s}
		sum = 0
		ROLES.map {|elt| new_roles.include?(elt.to_sym) ? 1 : 0 }.each_with_index {|elt,i| (elt > 0) ? (sum += 2**i) : nil }
		self.roles_mask = sum
		# self.roles_mask = (roles & ROLES).map { |r| ROLES.index(r.to_s)**2}.sum
	end

	def roles
		if self.roles_mask == nil
			self.roles_mask = 8
		end
		(self.roles_mask.to_s(2).rjust(4,'0')).reverse.split("").each_with_index.map { |does_have, index| ROLES[index].to_sym if does_have =='1' }.compact # & ((2**ROLES.count)-1)
	end
	
	def profile_image_url
		if self.image
			(self.image).url()
		else
			"default_user_image.png"
		end
	end

	def role?(role)
		self.roles.include?(role)
	end

	def default_role
		self.roles=( (self.roles.concat [:user]).uniq) if (self.roles_mask == 0 or self.roles_mask == nil)
		self.roles=( (self.roles.concat [:user, :author]).uniq) if self.account_type == 'project_creator'
	end

	def stripe_query_parameters
		URI.encode_www_form(STRIPE_PARAMETERS.map { |parm| [parm.to_s, self[parm]] } + [[:client_id, ENV["stripe_connect_client_id"]],[:response_type,'code']])
	end

	def self.from_omniauth(auth, logged_in_user)
		# first check if this provider/uid combo exists
		# 	
		# 	no, if there's a current user, add it to that
		#			no
		# foundAuth = User.find((auth[:provider]+'_uid').to_sym => auth[:uid])
		# debugger
		foundAuth = Authorization.where( :provider => auth.provider, :uid => auth.uid).first
		if foundAuth
			user = foundAuth.user
		else
			user = User.find_by_email(auth.info.email)
			if user
				#add this login to user
				user.authorizations.create(auth.slice(:provider,:uid))
			else
				if logged_in_user
					user = logged_in_user
				else
					user = User.create(:email => auth.info.email, :password => Devise.friendly_token[0,20], :terms_of_service => '1')
					user.skip_confirmation! unless user.email.blank?
					user.save
					user.reload
				end
				user.authorizations.create(:provider => auth.provider, :uid => auth.uid)
				logger.ap user
			end
		end
		if auth.info.provider == :stripe_connect
			user.stripe_secret_key = auth.credentials.token
			user.stripe_publishable_key = auth.info.stripe_publishable_key
			user.save
		end
		user
		# where(auth.slice(:provider,:uid)).first_or_create do |user|
		# 	user.provider = auth.provider
		# 	user.uid = auth.uid
		# 	user.email = auth.info.email
		# 	user.skip_confirmation! unless user.email.blank?
		# end
	end

	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], without_protection: true) do |user|
				user.attributes = params
				user.valid?
			end
			#authorization?
		else
			super
		end
	end


	def password_required?
		super && Authorization.where(:user_id => self.id).empty?
	end

	def name
		# remove this once i put names into the model
		full_name || email[/(.+)@/,1]
	end

	def full_name
		if !first_name.blank? and !last_name.blank?
			"#{first_name} #{last_name}"
		else
			nil
		end
	end

	def mail_email(*args)
		email
	end

end
