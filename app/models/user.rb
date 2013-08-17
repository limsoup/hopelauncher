require 'uri'
class User < ActiveRecord::Base
	acts_as_messageable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :stripe_connect]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles_mask, :provider, :uid, :stripe_connect_publishable_key, :stripe_connect_authorization_token, :stripe_customer_id,
  :legal_name, :statement_name, :statement_number, :ein, :first_name, :last_name, :date_of_birth, :street, :city,
  :state, :zip, :country, :under_review, :image, :remote_image_url

	before_save :default_role

	has_many :donations
  has_many :donated_projects, :through => :donations, :class_name => "Project", :inverse_of => :donators, :foreign_key => "project_id"
	has_many :created_projects, :class_name => "Project", :inverse_of => :creator
	has_many :authorizations

	mount_uploader :image, ImageUploader
	ROLES = %w[admin mod author user] 
	STRIPE_PARAMETERS = %w[email].map {|x| x.to_sym}

	def roles=(roles)
		roles.map! {|r| r.to_s}
		self.roles_mask = (roles & ROLES).map { |r| ROLES.index(r.to_s)**2}.sum
	end

	def roles
		(self.roles_mask || 0).to_s(2).reverse.split("").each_with_index.map { |does_have, index| ROLES[index].to_sym if does_have =='1' }.compact # & ((2**ROLES.count)-1)
	end

	def role?(role)
		roles.include?(role)
	end

	def default_role
		self.roles=[:user] if roles_mask == 0
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
		begin
			puts auth.provider
			puts auth.uid
			puts auth.info.stripe_connect_publishable_key
			puts auth.credentials.token
			foundAuth = Authorization.where( :provider => auth.provider.to_sym, :uid => auth.uid).first
			user = foundAuth.user
			if user.stripe_connect_authorization_token.nil? or user.stripe_connect_publishable_key.nil?
				user.stripe_connect_publishable_key = auth.info.stripe_publishable_key
				user.stripe_connect_authorization_token = auth.credentials.token
				puts user.stripe_connect_authorization_token
				user.save
			end
		rescue
			user = User.find_by_email(auth.info.email)
			if user
				#add this login to user
				user.authorizations.create(auth.slice(:provider,:uid))
			else
				if logged_in_user
					logged_in_user.authorizations.create(:provider => auth.provider, :uid => auth.uid)
					user = logged_in_user
				else
					user = User.create(:email => auth.info.email)
					user.skip_confirmation! unless user.email.blank?
				end
				if(auth.info.provider == :stripe_connect)
					user.stripe_connect_publishable_key = auth.info.stripe_publishable_key
					user.stripe_connect_authorization_token = auth.credentials.token #auth.credentials.token
				end
				if user.save
					user.authorizations.create(:provider => auth.provider, :uid => auth.uid)
				end
				# user.provider = auth.provider
				# user.uid = auth.uid
				# user.email = auth.info.email
			end
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
		super && Authorization.where(:user_id => id).empty?
	end

	def name
		# remove this once i put names into the model
		email[/(.+)@/,1]
	end

	def mail_email(*args)
		email
	end

end
